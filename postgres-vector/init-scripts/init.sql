# 初始化脚本示例
# CREATE EXTENSION IF NOT EXISTS vector;
# CREATE TABLE items (
#   id SERIAL PRIMARY KEY,
#   embedding vector(768),
#   metadata JSONB
# );
# CREATE INDEX ON items USING hnsw (embedding vector_cosine_ops);