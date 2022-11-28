#! /bin/sh

if [ "$1" ]; then
  SECRET_NAME="$1"
else
  SECRET_NAME="petinvent-secret"
fi

# Remove previous secret by the same name
( kubectl delete sealedsecrets.bitnami.com ${SECRET_NAME} ) > /dev/null 2>&1

# Generate random passwords
PASSGEN="head /dev/urandom | tr -dc A-Za-z0-9 | head -c64"
FLASK_SECRET_KEY=$(eval "$PASSGEN")
POSTGRESQL_PASSWORD=$(eval "$PASSGEN")
POSTGRESQL_POSTGRES_PASSWORD=$(eval "$PASSGEN")
REPMGR_PASSWORD=$(eval "$PASSGEN")

kubectl --namespace default \
  create secret \
  generic "${SECRET_NAME}" \
  --dry-run=client \
  --from-literal flaskSecretKey="${FLASK_SECRET_KEY}" \
  --from-literal postgresql-password="${POSTGRESQL_PASSWORD}" \
  --from-literal postgresql-postgres-password="${POSTGRESQL_POSTGRES_PASSWORD}" \
  --from-literal repmgr-password="${REPMGR_PASSWORD}" \
  --output json |
  kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=default \
      |
  tee "${SECRET_NAME}".yaml

kubectl create \
  --filename "${SECRET_NAME}".yaml

rm "${SECRET_NAME}".yaml

exit 0
