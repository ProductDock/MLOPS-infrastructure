variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "authorized_networks" {
 description= "Authorized networks for GKE cluster"
 type = list(map(string))
}
variable "argo_master_cidr" {
  type = string
  default = "172.16.0.0/28"
  description = "An internal IP address range for the control plane. This setting is permanent for this cluster and must be unique within the VPC."
}
variable "app_cluster_master_cidr" {
  type = string
  default = "172.30.0.0/28"
  description = "An internal IP address range for the control plane. This setting is permanent for this cluster and must be unique within the VPC."
}

variable "node_locations" {
  type = list
  default     = ["europe-west3-a"]
  description = "The node pool location"
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-1"
  description = "The name of the machine type to use for the cluster nodes"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "europe-west3"
}

variable "zone" {
  type  = string
  description = "The zone in a region"
  default = "europe-west3-a"
}

variable "cluster_secondary_subnet_pods_name"{
  type = string
  default = "gke-pods-1"
  description = "secondary subnetwork pods name"
}

variable "app_cluster_secondary_subnet_pods_name"{
  type = string
  default = "app-pods"
  description = "secondary subnetwork pods name"
}

variable "cluster_secondary_subnet_service_name"{
  type = string
  default = "gke-services-1"
   description = "secondary subnetwork service name"
}

variable "app_cluster_secondary_subnet_service_name"{
  type = string
  default = "app-services"
  description = "secondary subnetwork service name"
}

variable "nat_ip" {
  description = "Address that is created for nat router"
  type = string
  default = ""
}

variable "docker_username" {
  description = "Username for docker container hub registry"
  type = string
}
variable "docker_password" {
  description = "Password for docker hub container registry"
  type = string
}
variable "docker_email" {
  description = "Email for docker hub container registry"
  type = string
}
variable "docker_server" {
  description = "Server for docker hub container registry"
  default = "https://index.docker.io/v1/"
}

variable "github_org_name" {
  description = "Github organization name"
  type = string
}

variable "github_model_repo" {
  description = "Github model repository name"
  type = string
}

variable "github_model_deployment_repo" {
  description = "Github repository with the code for deploying model"
  type = string
}

variable "github_infrastructure_repo" {
  description = "Github repository with the infrastructure code"
  type = string
}

variable "project_number" {
  description = "Project number"
  type = string
}

variable "cluster_secondary_subnet_pods_range"{
  type = string
  default = "10.4.0.0/14"
  description = "secondary subnetwork pods range"
}

variable "cluster_secondary_subnet_service_range"{
  type = string
  default = "10.0.32.0/20"
  description = "secondary subnetwork service range"
}


variable "network"{
  type = string
  default = "gke-net-1"
  description = "VPC network name"
}

variable "subnetwork"{
  type = string
  default = "gke-subnet-1"
  description = "VPC subnetwork name"

}

variable "argo_subnetwork_range"{
  type = string
  default = "192.168.0.0/20"
  description = "primary subnetwork range"
}

variable "argo_destination_server_url"{
  type = string
  default = ""
  description = "argo destination server url"
}