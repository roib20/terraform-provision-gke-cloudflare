resource "kubernetes_manifest" "app-of-apps" {
  manifest = {
    "apiVersion" : "argoproj.io/v1alpha1",
    "kind" : "Application",
    "metadata" : {
      "name" : "argocd-app-of-apps",
      "namespace" : "argocd",
    },
    "spec" : {
      "project" : "default",
      "source" : {
        "repoURL" : "https://github.com/roib20/petinvent-gitops",
        "path" : "argocd/apps",
        "targetRevision" : "main"
      },
      "destination" : {
        "server" : "https://kubernetes.default.svc",
        "namespace" : "default"
      },
      "syncPolicy" : {
        "automated" : {
          "prune" : true,
          "selfHeal" : true
        }
      }
    }
  }
}
