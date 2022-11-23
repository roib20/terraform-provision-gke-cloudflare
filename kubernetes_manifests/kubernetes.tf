# Kubernetes provider

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "provider" {}

provider "kubernetes" {
    host  = "https://${var.kubernetes_cluster_host}"
    insecure = false

    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_certificate)
  }
