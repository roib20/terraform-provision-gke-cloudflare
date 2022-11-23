# gcp variables
variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
  sensitive   = true
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
  default     = "me-west1"
}

variable "zone" {
  description = "zone"
  default     = "me-west1-a"
}

variable "gke_location" {
  description = "The location (region or zone) of the cluster"
  default     = "me-west1-a"
}

variable "gke_num_nodes" {
  description = "number of gke nodes"
}

variable "machine_type" {
  description = "Google Compute Engine machine type"
  default     = "e2-medium"
}
