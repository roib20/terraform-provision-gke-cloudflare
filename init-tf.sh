#! /bin/sh

terraform init

terraform plan -target=module.gcp
terraform apply -target=module.gcp -auto-approve

gcloud container clusters get-credentials my4dkube-gke

/bin/sh get-cloudflare-secret.sh
/bin/sh gen-secrets.sh

terraform plan -target=module.helm_release
terraform apply -target=module.helm_release -auto-approve

terraform plan
terraform apply -auto-approve
