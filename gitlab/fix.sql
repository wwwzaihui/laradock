-- fix runner page 500
update application_settings 
SET
encrypted_customers_dot_jwt_signing_key= null,
encrypted_customers_dot_jwt_signing_key_iv =null,
runners_registration_token=null,
runners_registration_token_encrypted=null;
