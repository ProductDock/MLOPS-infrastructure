resource "google_service_account" "service_account" {
  account_id   = "argocd-admin-svc"
  description  = "Argo CD admin service account"
  display_name = "argocd-admin"
  project      = var.project_id
}

module "argocd_gke_cluster" {
  source              = "./modules/gcp_gke_cluster"
  project_id          = var.project_id
  cluster_name        = "argocd-cluster"
  cluster_description = "ArgoCD cluster"
  node_count          = 1
  authorized_networks = var.authorized_networks
  nat_ip = var.nat_ip
  master_cidr = var.argo_master_cidr
  service_account = google_service_account.service_account.email
  network_uri           = google_compute_network.vpc_net.self_link
  subnetwork_uri         = google_compute_subnetwork.vpc_subnet.self_link
  cluster_secondary_subnet_pods_name = var.cluster_secondary_subnet_pods_name
  cluster_secondary_subnet_service_name = var.cluster_secondary_subnet_service_name
}

# Apply after cluster creation
module "argo_cd" {
  source = "./modules/argocd"  
  github_deployment_repo = var.github_model_deployment_repo
  server_url = var.argo_destination_server_url
  providers = {
    helm = helm.argocd_cluster
  }
}

resource "google_service_account_iam_binding" "service-account-ksa-binding" {
  service_account_id = "${google_service_account.service_account.id}"
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${module.argo_cd.argo_cluster_namespace}/argocd-application-controller]",
    "serviceAccount:${var.project_id}.svc.id.goog[${module.argo_cd.argo_cluster_namespace}/argocd-server]"
  ]
}
