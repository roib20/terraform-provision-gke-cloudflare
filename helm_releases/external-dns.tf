resource "helm_release" "external-dns" {
  name                = "external-dns"
  repository          = "https://kubernetes-sigs.github.io/external-dns/"
  chart               = "external-dns"
  # version             = "1.16.1"

  namespace           = "default"
  create_namespace    = "true"

  values = [
    file("${path.module}/values/external-dns_values.yaml")
  ]

  set {
    name  = "provider.name"
    value = "cloudflare"
  }

  set {
    name  = "env[0].name"
    value = "CF_API_TOKEN"
  }

  set {
    name  = "env[0].valueFrom.secretKeyRef.name"
    value = "cloudflare-api-token-secret"
  }

  set {
    name  = "env[0].valueFrom.secretKeyRef.key"
    value = "api-token"
  }
}
