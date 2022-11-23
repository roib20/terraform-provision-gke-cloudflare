resource "helm_release" "cert-manager" {
  name                = "cert-manager"
  repository          = "https://charts.jetstack.io"
  chart               = "cert-manager"
  # version             = "1.10.1"

  namespace           = "default"
  create_namespace    = "true"

  values = [
    file("${path.module}/values/cert-manager_values.yaml")
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-prod"
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name  = "ingressShim.defaultIssuerGroup"
    value = "cert-manager.io"
  }
}
