resource "helm_release" "sealed-secrets" {
  name                = "sealed-secrets-controller"
  repository          = "https://bitnami-labs.github.io/sealed-secrets/"
  chart               = "sealed-secrets"
  # version             = "2.17.2"

  namespace           = "kube-system"
  create_namespace    = "true"

  values = [
    file("${path.module}/values/sealed-secrets_values.yaml")
  ]
}
