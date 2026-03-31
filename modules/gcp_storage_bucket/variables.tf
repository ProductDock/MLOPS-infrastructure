variable "name" {
  description = "The name of the bucket."
  type        = string
}

variable "project_id" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "location" {
  description = "The location of the bucket."
  type        = string
}

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  default     = null
}

variable "versioning" {
  description = "While set to true, versioning is fully enabled for this bucket."
  type        = bool
  default     = true
}

variable "uniform_bucket_level_access" {
  description = "While set to true, only bucket-level Identity and Access Management (IAM) permissions grant access to this bucket and the objects it contains."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

variable "public_access_prevention" {
  description = "Prevents public access to a bucket. Acceptable values are inherited or enforced. If inherited, the bucket uses public access prevention, only if the bucket is subject to the public access prevention organization policy constraint."
  type        = string
  default     = "inherited"
}

variable "prefix" {
  description = "Prefix user or group or serviceaccount"
  type        = string
  default     = "serviceAccount"
}

variable "bucket_roles" {
   description = "The list of IAM members to grant permissions on the bucket."
   type = list
   default = []
}

variable "service_account_address" {
  description = "Service account address"
  type        = string
}





