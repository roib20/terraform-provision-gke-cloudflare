# Terraform - Provision a GKE Cluster with Cloudflare ingress and ArgoCD

This repo contains three Terraform modules to provision a GKE cluster (with VPC and subnet), then deploy Helm charts and Kubernetes manifests.

The included deployments are designed for a fully-functioning ingress controller that works with Cloudflare — by utilizing [ingress-nginx](https://github.com/kubernetes/ingress-nginx), [cert-manager](https://cert-manager.io/) and [ExternalDNS](https://github.com/kubernetes-sigs/external-dns). In addition, [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) and [ArgoCD](https://argoproj.github.io/cd/) are also deployed.

Note: the GCP module in this repo is a modified fork of [learn-terraform-provision-gke-cluster](https://github.com/hashicorp/learn-terraform-provision-gke-cluster); the MPL-2.0 license is adhered to.

## What is needed to deploy?
The `init-tf.sh` script does everything needed in order to deploy the full environment in the correct order. In order to use this script, you need a Unix shell (the script is written for POSIX shell - desgined to have wide compatibility in Linux, macOS and WSL environments).

In addition, you will need to have the following packages installed:  
* [gcloud CLI](https://cloud.google.com/sdk/docs/install) (configured with `gcloud init`)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kubeseal](https://formulae.brew.sh/formula/kubeseal)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)

For Cloudflare, you should own a domain and register it in Cloudflare. Then generate an API token with the permissions described here: https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens


## How to deploy this?
1) In your shell, run `gcloud init` 

2) Edit the `terraform.tfvars.example` file:
* Use the command: `cp "terraform.tfvars.example" "terraform.tfvars"`
* Edit `terraform.tfvars` using a text editor. Make sure to add an appropriate GCP project ID (according to what you configured in step 1).

3) Run the `init-tf.sh` script

4) When running the script, the GKE cluster would be provisioned first, together with a sealed-secrets controller. You would then be asked to provide your Cloudflare API token which will be configured as a sealed secret and used for the DNS-01 challange and ExternalDNS.

5) When the script completes, run `kubectl get pods -A` to ensure everything deployed correctly.

## How to destroy this?
Destroying is much simpler. Simply run `terraform destroy` from the project directory.

## FAQ
### Can I use this without Cloudflare?
Yes, but you will need to modify the cluster issuers and ExternalDNS to work with a different DNS provider.

### Can I use this without GCP?
In theory yes but it will require the modules to be heavily rewritten. This is not recommended.

### Can I use this in production?
This is not recommended. These modules are designed just for learning (e.g. using a GCP free trial).

### Can I deploy other Helm charts?
Yes, in the "helm_release" folder, add your Helm charts as a tf file containing a "helm_release" resource.

### Can I deploy other Kubernetes manifests?
Yes, in the "kubernetes_manifest" folder, add your Helm charts as a tf file containing a "kubernetes_manifest" resource. Make sure the manifest is formatted as JSON, not YAML.

### How do I access the ingress?
Apply an approriate Ingress resource for your service (see Kuberenets documentation) and add the following annotations:
```
annotations:
    external-dns.alpha.kubernetes.io/hostname: "your.domain,*.your.domain" # MODIFY THIS
    cert-manager.io/cluster-issuer: letsencrypt-prod # or letsencrypt-staging
    kubernetes.io/tls-acme: "true"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
```

### I am getting an SSL/TLS error or redirect error while accessing my domain after applying the ingress resource. How can I solve this?
See Cloudflare Docs: [ERR_TOO_MANY_REDIRECTS](https://developers.cloudflare.com/ssl/troubleshooting/too-many-redirects/)

It is recommended to set the SSL/TLS encryption mode in Cloudflare to `Full` or `Full (strict)`; if using a staging certificate, use `Full`. With a prod certificate, both modes can be used.
