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
