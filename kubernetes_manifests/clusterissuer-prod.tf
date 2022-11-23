resource "kubernetes_manifest" "clusterissuer-prod" {
  manifest = {
    "apiVersion" : "cert-manager.io/v1",
    "kind" : "ClusterIssuer",
    "metadata" : {
      "name" : "letsencrypt-prod"
    },
    "spec" : {
      "acme" : {
        "server" : "https://acme-v02.api.letsencrypt.org/directory",
        "privateKeySecretRef" : {
          "name" : "letsencrypt-prod"
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
