# Learn Terraform - Provision a GKE Cluster

This repo contains three Terraform modules to provision a GKE cluster (with VPC and subnet), then deploy Helm charts and Kubernetes manifests.

The included deployments are designed for a fully-functioning ingress controller that works with Cloudflare — by utilizing [ingress-nginx](https://github.com/kubernetes/ingress-nginx), [cert-manager](https://cert-manager.io/) and [ExternalDNS](https://github.com/kubernetes-sigs/external-dns). In addition, [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) and [ArgoCD](https://argoproj.github.io/cd/) are also deployed.

The GCP module in this repo is a modified fork of [learn-terraform-provision-gke-cluster](https://github.com/hashicorp/learn-terraform-provision-gke-cluster); the MPL-2.0 license is maintained.

## What is needed to deploy?
The `init-tf.sh` script does everything needed in order to deploy the full environment in the correct order. In order to use this script, you need a Unix shell (the script is written for POSIX shell, desgined to have wide compatibility in Linux, macOS and WSL environments).

In addition, you will need to have the following packages installed:  
* [gcloud CLI](https://cloud.google.com/sdk/docs/install) (configured with `gcloud init`)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kubeseal](https://formulae.brew.sh/formula/kubeseal)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)

For Cloudflare, you should own a domain and register it in Cloudflare. Then generate an API token with the permissions described here: https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens


## How to deploy this?
1) In your shell, run `gcloud init` 

2) Edit the `terraform.tfvars.example` file;
Use the command: `cp 'terraform.tfvars.example' 'terraform.tfvars'`
Then edit using a text editor. Make sure to add an appropriate GCP project ID (according to what you configured in step 1).

3) Run the `init-tf.sh` script

4) When running the script, the GKE cluster would be provisioned first together with a sealed-secrets controller. You would then be asked to provide your Cloudflare API token which will be configured as a sealed secret and used for the DNS-01 challange and ExternalDNS.

5) When the script completes, run `kubectl get pods -A` to ensure everything deployed correctly.

## How to destroy this?
Destroying is much simpler. Simply run `terraform destroy` from the project directory.
