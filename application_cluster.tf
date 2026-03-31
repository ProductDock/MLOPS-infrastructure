locals {
  nat_ips = [{
      cidr_block = "${var.nat_ip}"
      display_name = "NAT IP"
  }]
  
   merged_authorized_networks = merge({ for elem in concat(local.nat_ips, var.authorized_networks) : elem.display_name => elem.cidr_block})

  merged_authorized_networks_list = [
    for name, cidr in local.merged_authorized_networks : {
      display_name = name
      cidr_block   = cidr
    }
  ]
}

module "app_cluster" {
  source              = "./modules/gcp_gke_cluster"
  project_id          = var.project_id
  cluster_name        = "application-cluster"
  cluster_description = "Application cluster"
  node_count          = 1
  authorized_networks = local.merged_authorized_networks_list
  nat_ip = ""
  master_cidr = var.app_cluster_master_cidr
  service_account = google_service_account.service_account.email
  network_uri           = google_compute_network.vpc_net.self_link
  subnetwork_uri         =  google_compute_subnetwork.vpc_subnet.self_link
  cluster_secondary_subnet_pods_name = var.cluster_secondary_subnet_pods_name
  cluster_secondary_subnet_service_name = var.cluster_secondary_subnet_service_name
}
