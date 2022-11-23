# Helm provider

data "google_client_config" "provider" {}

provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.primary.endpoint}"
    insecure = false

    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

resource "helm_release" "sealed-secrets" {
  name                = "sealed-secrets-controller"
  repository          = "https://charts.bitnami.com/bitnami"
  chart               = "sealed-secrets"
  # version             = "1.1.12"

  namespace           = "default"
  create_namespace    = "true"

  values = [
    file("${path.module}/values/sealed-secrets_values.yaml")
  ]
}
