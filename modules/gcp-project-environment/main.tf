locals {
  project_name = "${lower(var.app_name)}-${lower(var.app_env)}"
  default_labels = {
    app_env = var.app_env
  }
  default_activate_apis = ["cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "storage.googleapis.com",
    "dlp.googleapis.com",
    "serviceusage.googleapis.com",
    "recommender.googleapis.com"
  ]
  activate_apis = distinct(concat(var.activate_apis, local.default_activate_apis))
}

resource "random_id" "project_id_suffix" {
  byte_length = 3
}

module "project_factory" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 11.2.2"
  name                    = local.project_name
  project_id              = "${local.project_name}-${random_id.project_id_suffix.hex}"
  org_id                  = var.org_id
  billing_account         = var.billing_account_id
  folder_id               = var.folder_id
  create_project_sa       = true
  default_service_account = "keep"
  labels                  = merge(local.default_labels, var.project_labels)
  activate_apis           = local.activate_apis
}

# Service Account for Terraform to run as.
resource "google_service_account" "tf_service_account" {
  account_id   = "tf-state"
  project      = module.project_factory.project_id
  display_name = "Terraform Service Account"
  description  = "The Terraform Google Cloud Platform Service Account for project ${local.project_name}."
}

# This requires the terraform to be run regularly.
resource "time_rotating" "tf_service_account_key_rotation" {
  rotation_days = 30
}

resource "google_service_account_key" "tf_service_account_key" {
  service_account_id = google_service_account.tf_service_account.name

  keepers = {
    rotation_time = time_rotating.tf_service_account_key_rotation.rotation_rfc3339
  }
}

resource "github_actions_secret" "example_secret" {
  repository      = var.repo_name
  secret_name     = "SA_KEY_${upper(var.app_env)}"
  encrypted_value = google_service_account_key.tf_service_account_key.private_key
}

# Bucket for Terraform state.
resource "google_storage_bucket" "tf_state_bucket" {
  name                        = "${module.project_factory.project_number}-tfstate"
  project                     = module.project_factory.project_id
  location                    = "US"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "tf_service_account_iam_member" {
  bucket = google_storage_bucket.tf_state_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.tf_service_account.email}"
}