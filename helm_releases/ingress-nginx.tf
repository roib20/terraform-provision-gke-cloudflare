resource "helm_release" "ingress-nginx" {
  name              = "ingress-nginx"
  repository        = "https://kubernetes.github.io/ingress-nginx"
  chart             = "ingress-nginx"
  # version           = "4.12.2"

  namespace         = "ingress-nginx"
  create_namespace  = "true"

  values = [
    file("${path.module}/values/ingress-nginx_values.yaml")
  ]

  set {
    name  = "controller.ingressClassResource.default"
    value = "true"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
}
