terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.15.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.7.1"
    }

  }

  required_version = ">= 1.3.4"
}
