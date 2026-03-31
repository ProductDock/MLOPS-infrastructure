terraform {
  required_version = "~> 1.5.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.59.0"
    }

    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.84.0"
    } 

     kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.19"
    }
  }
} 

data "google_client_config" "default" {}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
    alias = "argocd"
    host                   = "https://${module.argocd_gke_cluster.created_cluster.endpoint}"
    cluster_ca_certificate = base64decode(module.argocd_gke_cluster.created_cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
}

provider "helm" {
  alias = "argocd_cluster"
  kubernetes = {
    host                   = "https://${module.argocd_gke_cluster.created_cluster.endpoint}"
    cluster_ca_certificate = base64decode(module.argocd_gke_cluster.created_cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

provider "kubernetes" {
    alias = "application"
    host                   = "https://${module.app_cluster.created_cluster.endpoint}"
    cluster_ca_certificate = base64decode(module.app_cluster.created_cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
}

