variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "europe-west3"
}

variable "cluster_name" {
  type        = string
  default     = "cluster"
  description = "The name of the cluster to appear on the Google Cloud Console"
}

variable "cluster_description" {
  type        = string
  default     = "Cluster"
  description = "A description for the cluster"
}

variable "service_account_id" {
  type        = string
  default     = "gke-service-account-id"
  description = "Service account id"
}

variable "machine_type" {
  type        = string
  default     = "n1-standard-1"
  description = "The name of the machine type to use for the cluster nodes"
}

variable "node_count" {
  default     = 1
  description = "The number of cluster nodes"
}

variable "node_locations" {
  type = list
  default     = ["europe-west3-a"]
  description = "The node pool location"
}

variable "cluster_secondary_subnet_pods_name"{
  type = string
  default = "gke-pods-1"
  description = "secondary subnetwork pods name"
}

variable "cluster_secondary_subnet_service_name"{
  type = string
  default = "gke-services-1"
   description = "secondary subnetwork service name"
}

variable "master_cidr" {
  type = string
  default = "172.16.0.0/28"
  description = "An internal IP address range for the control plane. This setting is permanent for this cluster and must be unique within the VPC."
}

variable "authorized_networks" {
  type = list(map(string))
}

variable "nat_ip" {
  type = string
}

variable "service_account" {
  type = string
}

variable "network_uri" {
  description = "The URI of the created network resource"
  type = string
}

variable "subnetwork_uri" {
  description = "The URI of the created subnetwork resource"
  type = string
}