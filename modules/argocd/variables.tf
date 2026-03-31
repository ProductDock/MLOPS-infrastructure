variable "argocd_chart_version" {
  type    = string
  default = "4.9.7"
}

variable "argocd_chart_name" {
  type    = string
  default = "argo-cd"
}

variable "argocd_k8s_namespace" {
  type    = string
  default = "argocd"
}

variable "cluster_name" {
  type        = string
  default     = "cluster"
  description = "The name of the cluster where ArgoCD will be installed"
}

variable "region" {
  type        = string
  description = "The region where the cluster for ArgoCD is created"
  default     = "europe-west3"
}

variable "github_deployment_repo" {
  description = "Github deployment repository name"
  type = string
}

variable "server_url" {
  description = "Destination server url"
  type = string
}