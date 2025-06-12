#! /bin/sh

valid_string="This API Token is valid and active"
valid_token=false

while [ ${valid_token} = false ]
do
# Ask user to enter Cloudflare API token
stty -echo
printf "Enter Cloudflare API token: "
read -r CLOUDFLARE_API_TOKEN
stty echo
printf "\n"

if curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type:application/json" |
    grep -q "$valid_string"; then
    valid_token=true
    echo "Valid Cloudflare API token"
else
    echo "Invalid Cloudflare API token.
    For getting your token, see instructions here:
    https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens"
fi
done

SECRET_NAME="cloudflare-api-token-secret"
NAMESPACE_FOR_SECRET="default"
NAMESPACE_FOR_SEALED_SECRETS_CONTROLLER="kube-system"

# Remove previous secret by the same name
( kubectl delete --namespace "${NAMESPACE_FOR_SECRET}" sealedsecrets.bitnami.com "${SECRET_NAME}" ) > /dev/null 2>&1

kubectl --namespace "${NAMESPACE_FOR_SECRET}" \
  create secret \
  generic "${SECRET_NAME}" \
  --dry-run=client \
  --from-literal api-token="${CLOUDFLARE_API_TOKEN}" \
  --output json |
  kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace="${NAMESPACE_FOR_SEALED_SECRETS_CONTROLLER}" \
      |
  tee "${SECRET_NAME}".yaml

kubectl create \
  --namespace "${NAMESPACE_FOR_SECRET}"\
  --filename "${SECRET_NAME}".yaml

rm "${SECRET_NAME}".yaml

exit 0
