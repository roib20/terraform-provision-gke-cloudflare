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

SECRET_NAME="cloudflare-secret"

# Remove previous secret by the same name
( kubectl delete sealedsecrets.bitnami.com ${SECRET_NAME} ) > /dev/null 2>&1

kubectl --namespace default \
  create secret \
  generic "${SECRET_NAME}" \
  --dry-run=client \
  --from-literal cloudflare_api_token="${CLOUDFLARE_API_TOKEN}" \
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
