resource "kubernetes_manifest" "clusterissuer-staging" {
  manifest = {
    "apiVersion" : "cert-manager.io/v1",
    "kind" : "ClusterIssuer",
    "metadata" : {
      "name" : "letsencrypt-staging"
    },
    "spec" : {
      "acme" : {
        "server" : "https://acme-staging-v02.api.letsencrypt.org/directory",
        "privateKeySecretRef" : {
          "name" : "letsencrypt-staging"
        },
        "solvers" : [
          {
            "dns01" : {
              "cloudflare" : {
                "apiTokenSecretRef" : {
                  "name" : "cloudflare-secret",
                  "key" : "cloudflare_api_token"
                }
              }
            }
          }
        ]
      }
    }
  }
}
