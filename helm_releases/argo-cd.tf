resource "helm_release" "argo-cd" {
  name              = "argocd"
  repository        = "https://argoproj.github.io/argo-helm"
  chart             = "argo-cd"
  # version           = "8.0.6"

  namespace         = "argocd"
  create_namespace  = "true"

  values = [
    file("${path.module}/values/argo-cd_values.yaml")
  ]
}
