terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.44"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.7"
    }

  }

  required_version = "~> 1"
}
