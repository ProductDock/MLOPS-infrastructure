resource "google_compute_network" "vpc_net" {
  name          = var.network
  project       = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnetwork
  project       = var.project_id
  ip_cidr_range = var.argo_subnetwork_range
  region        = var.region
  network       = google_compute_network.vpc_net.self_link
  private_ip_google_access = true

  secondary_ip_range = [
    {
      range_name    = var.cluster_secondary_subnet_pods_name
      ip_cidr_range = var.cluster_secondary_subnet_pods_range
    },
    {
      range_name    = var.cluster_secondary_subnet_service_name
      ip_cidr_range = var.cluster_secondary_subnet_service_range
    }
  ]
 }

resource "google_compute_router" "router" {
  name    = "router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc_net.self_link
}

resource "google_compute_address" "address" {
  name   = "nat-ip"
  region = google_compute_subnetwork.vpc_subnet.region
}

resource "google_compute_router_nat" "nat" {
  name    = "router-nat"
  project = var.project_id
  router  = google_compute_router.router.name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.address.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnet.self_link

    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.vpc_subnet.secondary_ip_range.0.range_name,
      google_compute_subnetwork.vpc_subnet.secondary_ip_range.1.range_name
    ]
  }
}