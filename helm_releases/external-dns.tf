resource "helm_release" "external-dns" {
  name                = "external-dns"
  repository          = "https://charts.bitnami.com/bitnami"
  chart               = "external-dns"
  # version             = "0.12.2"

  namespace           = "default"
  create_namespace    = "true"

  values = [
    file("${path.module}/values/external-dns_values.yaml")
  ]

  set {
    name  = "provider"
    value = "cloudflare"
  }

  set_sensitive {
    name  = "cloudflare.secretName"
    value = "cloudflare-secret"
  }

  set {
    name  = "cloudflare.proxied"
    value = "true"
  }
}
