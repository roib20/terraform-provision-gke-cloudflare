variable "gke_username" {
  default     = ""
  description = "GKE username"
}

variable "gke_password" {
  default     = ""
  description = "GKE password"
  sensitive   = true
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "gke_location" {
  description = "The location (region or zone) of the cluster"
}

variable "gke_num_nodes" {
  description = "number of GKE nodes"
}

variable "machine_type" {
  description = "Google Compute Engine machine type"
}

variable "gke_deletion_protection" {
  description = "Whether Terraform will be prevented from destroying the cluster. Deleting this cluster via terraform destroy or terraform apply will only succeed if this field is false in the Terraform state."
  default = false
}
