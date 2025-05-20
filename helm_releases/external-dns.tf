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
