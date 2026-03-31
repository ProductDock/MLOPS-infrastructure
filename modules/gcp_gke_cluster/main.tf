resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  description              = var.cluster_description
  network            = var.network_uri
  subnetwork         = var.subnetwork_uri

  ip_allocation_policy {
    cluster_secondary_range_name = var.cluster_secondary_subnet_pods_name
    services_secondary_range_name = var.cluster_secondary_subnet_service_name
  }

   private_cluster_config {
      enable_private_endpoint = false
      enable_private_nodes = true
      master_ipv4_cidr_block = var.master_cidr
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each   = var.authorized_networks
      content {
        cidr_block = cidr_blocks.value["cidr_block"]
        display_name = cidr_blocks.value["display_name"]
      }     
    } 
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  } 
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.cluster_name}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_locations = var.node_locations
  node_count = var.node_count

  node_config {
    service_account = var.service_account
    preemptible  = true
    machine_type = var.machine_type
    resource_labels = {
        "goog-gke-node-pool-provisioning-model" = "spot"
    }
    kubelet_config {
      cpu_cfs_quota  = false 
      pod_pids_limit = 0
      cpu_manager_policy = "none"
   }
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


