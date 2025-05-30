module "gcp" {
  source = "./gcp"

  gke_username = var.gke_username
  gke_password = var.gke_password
  project_id = var.project_id
  region = var.region
  zone = var.zone

  gke_location = var.gke_location
  gke_num_nodes = var.gke_num_nodes
  machine_type = var.machine_type
}

module "helm_releases" {
  source = "./helm_releases"

  gke_username = var.gke_username
  gke_password = var.gke_password
  project_id = var.project_id
  region = var.region
  zone = var.zone

  kubernetes_cluster_host = module.gcp.kubernetes_cluster_host
  kubernetes_cluster_ca_certificate = module.gcp.kubernetes_cluster_ca_certificate
}

module "kubernetes_manifests" {
  source = "./kubernetes_manifests"

  gke_username = var.gke_username
  gke_password = var.gke_password
  project_id = var.project_id
  region = var.region
  zone = var.zone

  kubernetes_cluster_host = module.gcp.kubernetes_cluster_host
  kubernetes_cluster_ca_certificate = module.gcp.kubernetes_cluster_ca_certificate
}
