provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC
resource "google_compute_network" "vpc" {
  name                        = "${var.project_id}-vpc"
  auto_create_subnetworks     = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name                        = "${var.project_id}-subnet"
  region                      = var.region
  network                     = google_compute_network.vpc.name
  ip_cidr_range               = "10.10.0.0/24"
  private_ip_google_access    = "true"
}
