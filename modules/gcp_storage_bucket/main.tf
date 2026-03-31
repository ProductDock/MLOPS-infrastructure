resource "google_storage_bucket" "bucket" {
  location                    = var.location
  name                        = var.name
  project                     = var.project_id
  public_access_prevention    = var.public_access_prevention
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  force_destroy = var.force_destroy

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      num_newer_versions = 1
      with_state         = "ARCHIVED"
    }
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      days_since_noncurrent_time = 7
      with_state                 = "ANY"
    }
  }

  versioning {
    enabled = var.versioning
  }
}

resource "google_storage_bucket_iam_member" "bucket_iam_member" {
  for_each = toset(var.bucket_roles)
  bucket = var.name
  role   = each.key
  member = "${var.prefix}:${var.service_account_address}"
}