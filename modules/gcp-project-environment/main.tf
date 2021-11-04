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