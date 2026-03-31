output "env_dynamic_url" {
  value = "https://${google_container_cluster.primary.endpoint}"
}

output "created_cluster" {
  value = google_container_cluster.primary
}

