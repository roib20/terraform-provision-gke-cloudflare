#! /bin/sh

if [ "$1" = "-auto-approve" ]; then
    AUTO_APPROVE="$1"
else
    AUTO_APPROVE=""
fi

terraform init

project_id=$(echo "var.project_id" | terraform console -var-file terraform.tfvars)

# terraform plan -target=module.gcp
terraform apply -target=module.gcp "$AUTO_APPROVE"

gcloud container clusters get-credentials "$project_id"

/bin/sh get-cloudflare-secret.sh

# terraform plan -target=module.helm_release
terraform apply -target=module.helm_release "$AUTO_APPROVE"

# terraform plan
terraform apply "$AUTO_APPROVE"

exit 0
