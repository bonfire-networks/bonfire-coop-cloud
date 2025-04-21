#/bin/sh

# NOTE: this script should no longer be needed now that we have `# length=128` next to these secrets in the .env

# abra app secret generate --all $1 

s1=$(openssl rand -base64 128)
s2=$(openssl rand -base64 128)
s3=$(openssl rand -base64 128)

abra app secret insert $1 secret_key_base v2 "$s1"
abra app secret insert $1 signing_salt v2 "$s2"
abra app secret insert $1 encryption_salt v2 "$s3"
