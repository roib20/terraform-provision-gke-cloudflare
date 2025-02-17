resource "helm_release" "argo-cd" {
  name              = "argocd"
  repository        = "https://argoproj.github.io/argo-helm"
  chart             = "argo-cd"
  # version           = "5.14.1"

  namespace         = "argocd"
  create_namespace  = "true"

  values = [
    file("${path.module}/values/argo-cd_values.yaml")
  ]
}
