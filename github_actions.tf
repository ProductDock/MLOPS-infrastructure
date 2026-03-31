resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  description  = "Github actions will access bucket from github actions"
  display_name = "github-actions"
  project = var.project_id  
  }

resource "google_iam_workload_identity_pool" "github-actn-identity-pool" {
  workload_identity_pool_id = "github-actn-pool"
}

resource "google_iam_workload_identity_pool_provider" "github-actions-identity-pool-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-actn-identity-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "github"
  attribute_mapping                  = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  attribute_condition = <<EOT
    attribute.repository == "${var.github_org_name}/${var.github_model_deployment_repo}" || 
    attribute.repository == "${var.github_org_name}/${var.github_model_repo}" &&
    assertion.ref_type == "branch" ||
    assertion.ref_type == "tag"
  EOT
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "sv-account-wif-tokencreator-iam-member" {
  service_account_id = google_service_account.github_actions.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github-actn-identity-pool.workload_identity_pool_id}/attribute.repository/${var.github_org_name}/${var.github_model_repo}"
}

module "dvc_storage_bucket" {
  source                   = "./modules/gcp_storage_bucket"
  storage_class            = "STANDARD"
  project_id               = var.project_id
  location                 = "EUROPE-WEST1"
  name                     = "telemanom-model-data"
  public_access_prevention = "enforced"
  service_account_address  = google_service_account.github_actions.email
  bucket_roles             = ["roles/storage.legacyObjectReader", "roles/storage.legacyBucketOwner"]
  prefix                   = "serviceAccount"
}
