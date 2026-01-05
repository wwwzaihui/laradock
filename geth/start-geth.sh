#!/bin/sh
set -euo pipefail

DATADIR="/data"
CONFIGDIR="/config"
RPC_PORT="${GETH_HTTP_PORT:-8547}"
WS_PORT="${GETH_WS_PORT:-8548}"
CHAIN_ID="${GETH_CHAIN_ID:-77}"
ACCOUNTS_LIMIT="${GETH_ACCOUNTS:-}"
DEFAULT_BALANCE_WEI="${GETH_DEFAULT_BALANCE:-10000000000000000000000}"
GAS_LIMIT_DEC="${GETH_GAS_LIMIT:-30000000}"
GAS_LIMIT_HEX=$(printf '0x%X' "$GAS_LIMIT_DEC")

# Ensure password file exists
if [ ! -f "$CONFIGDIR/password.txt" ]; then
  echo "password" > "$CONFIGDIR/password.txt"
fi

# Resolve accounts.json path (from /config)
ACCOUNTS_JSON=""
if [ -f "$CONFIGDIR/accounts.json" ]; then
  ACCOUNTS_JSON="$CONFIGDIR/accounts.json"
fi

# Import accounts from accounts.json always (safe to re-import)
if [ -z "$ACCOUNTS_JSON" ]; then
  echo "[warn] accounts.json not found. Will create a default account if none exists."
else
  echo "[init] Importing accounts from $ACCOUNTS_JSON"
  # Robust extraction of private keys from JSON (handles CRLF and spacing)
  awk -F '"' '/privateKey/ {print $4}' "$ACCOUNTS_JSON" | while read -r PK; do
    [ -z "$PK" ] && continue
    echo "$PK" | sed 's/^0x//' > /tmp/keyhex
    echo "[init] Importing key $PK"
    geth account import --datadir "$DATADIR" --password "$CONFIGDIR/password.txt" /tmp/keyhex || true
    rm -f /tmp/keyhex
  done
fi

# Build unlock list from imported accounts
UNLOCK=$(geth account list --datadir "$DATADIR" | sed -n 's/.*{\([0-9a-fA-F]\{40\}\)}.*/0x\1/p' | tr '\n' ',' | sed 's/,$//')
FIRST_ADDR=$(echo "$UNLOCK" | awk -F, '{print $1}')

if [ -z "$FIRST_ADDR" ]; then
  echo "[warn] No accounts found after import. Creating a new default account for coinbase..."
  geth account new --datadir "$DATADIR" --password "$CONFIGDIR/password.txt" >/dev/null
  UNLOCK=$(geth account list --datadir "$DATADIR" | sed -n 's/.*{\([0-9a-fA-F]\{40\}\)}.*/0x\1/p' | tr '\n' ',' | sed 's/,$//')
  FIRST_ADDR=$(echo "$UNLOCK" | awk -F, '{print $1}')
fi

# Optionally limit the number of unlocked accounts
if [ -n "$ACCOUNTS_LIMIT" ]; then
  UNLOCK=$(echo "$UNLOCK" | tr ',' '\n' | head -n "$ACCOUNTS_LIMIT" | tr '\n' ',' | sed 's/,$//')
  FIRST_ADDR=$(echo "$UNLOCK" | awk -F, '{print $1}')
fi

# Generate genesis.json with Clique using FIRST_ADDR as initial signer (overwrite each run)
echo "[init] Generating genesis.json with chainId $CHAIN_ID and Clique signer $FIRST_ADDR"
ADDR_NO0X=$(echo "$FIRST_ADDR" | sed 's/^0x//')
  VANITY="0000000000000000000000000000000000000000000000000000000000000000" # 64 zeros
  SEAL="0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" # 130 zeros

  # Build alloc mapping with uniform balance per account (in wei)
  BALANCE_WEI="$DEFAULT_BALANCE_WEI"
  ALLOC_START="{"
  ALLOC_BODY=""
  for addr in $(echo "$UNLOCK" | tr ',' ' '); do
    if [ -n "$ALLOC_BODY" ]; then
      ALLOC_BODY="$ALLOC_BODY,"
    fi
    ALLOC_BODY="$ALLOC_BODY\"$addr\":{\"balance\":\"$BALANCE_WEI\"}"
  done
  ALLOC_END="}"

cat > "$CONFIGDIR/genesis.json" <<EOF
{
  "config": {
    "chainId": $CHAIN_ID,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "muirGlacierBlock": 0,
    "berlinBlock": 0,
  "londonBlock": 0,
  "shanghaiTime": 0,
  "clique": { "period": 1, "epoch": 30000 }
  },
  "nonce": "0x0",
  "timestamp": "0x0",
  "extraData": "0x${VANITY}${ADDR_NO0X}${SEAL}",
  "gasLimit": "$GAS_LIMIT_HEX",
  "difficulty": "0x1",
  "mixHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": ${ALLOC_START}${ALLOC_BODY}${ALLOC_END},
  "number": "0x0",
  "gasUsed": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "baseFeePerGas": null
}
EOF

# Initialize datadir with our custom genesis every run to avoid DB version mismatches
echo "[init] Preparing datadir with custom genesis (chainId $CHAIN_ID)"
rm -rf "$DATADIR/geth" || true
geth init --datadir "$DATADIR" "$CONFIGDIR/genesis.json"
touch "$DATADIR/.custom_genesis_$CHAIN_ID" || true

echo "[run] Starting geth on RPC :$RPC_PORT (chainId $CHAIN_ID)"
exec geth \
  --http --http.addr 0.0.0.0 --http.port "$RPC_PORT" --http.api eth,net,web3,debug,txpool,personal \
  --http.vhosts "*" --http.corsdomain "*" \
  --ws --ws.addr 0.0.0.0 --ws.port "$WS_PORT" --ws.api eth,net,web3,debug,txpool,personal \
  --datadir "$DATADIR" \
  --networkid "$CHAIN_ID" \
  --allow-insecure-unlock \
  --unlock "$UNLOCK" \
  --password "$CONFIGDIR/password.txt" \
  --mine \
  --miner.etherbase "$FIRST_ADDR" \
  --nodiscover \
  --verbosity 3