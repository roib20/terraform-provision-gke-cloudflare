#! /bin/sh

if [ "$1" = "-auto-approve" ]; then
    AUTO_APPROVE="$1"
else
    AUTO_APPROVE=""
fi

gcloud services enable container.googleapis.com
terraform init

# terraform plan -target=module.gcp
terraform apply -target=module.gcp "$AUTO_APPROVE"

PROJECT_ID=$(echo "var.project_id" |
    terraform console -var-file terraform.tfvars |
    sed -e 's/^"//' -e 's/"$//' | \
        sed -e "s/^'//" -e "s/'$//")

ZONE=$(echo "var.zone" |
    terraform console -var-file terraform.tfvars |
    sed -e 's/^"//' -e 's/"$//' | \
        sed -e "s/^'//" -e "s/'$//")

REGION=$(echo "var.region" |
    terraform console -var-file terraform.tfvars |
    sed -e 's/^"//' -e 's/"$//' | \
        sed -e "s/^'//" -e "s/'$//")

gcloud container clusters get-credentials "$PROJECT_ID-gke" --zone "$ZONE" || \
gcloud container clusters get-credentials "$PROJECT_ID-gke" --region "$REGION"

/bin/sh get-cloudflare-secret.sh

# terraform plan -target=module.helm_releases
terraform apply -target=module.helm_releases "$AUTO_APPROVE"

# terraform plan
terraform apply "$AUTO_APPROVE"

exit 0
