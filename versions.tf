terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.35"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.17"
    }

  }

  required_version = "~> 1"
}
