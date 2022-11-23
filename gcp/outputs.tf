output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "zone" {
  value       = var.zone
  description = "GCloud Zone"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_location" {
  value       = var.gke_location
  description = "GKE Cluster location"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_ca_certificate" {
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  description = "GKE Cluster CA certificate"
}

output "kubectl" {
  value = "gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --location $(terraform output -raw kubernetes_cluster_location)"
}
