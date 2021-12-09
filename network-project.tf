module "network_project_repo" {
  source = "./modules/github-repository"

  // Organization is set up per-provider.
  repo_name = "network-project"
}


# Technically it's prod but the network project will be "environmentless."
module "network_project_prod" {
  source = "./modules/gcp-project-environment"

  app_name           = "network"
  app_env            = "prod"
  repo_name          = module.network_project_repo.repo_name
  org_id             = data.google_organization.lavender_bison.id
  folder_id          = google_folder.prod.id
  billing_account_id = var.billing_account_id
  activate_apis = [
    "compute.googleapis.com",
    "dns.googleapis.com"
  ]
  project_labels = {
  }
  billing_budget          = "200"
  state_bucket_project_id = var.project_id
}

// This project and service account get special org-level privileges because of shared
resource "google_organization_iam_member" "network_project_prod_xpn" {
  org_id = var.org_id
  role   = "roles/compute.xpnAdmin"
  member = "serviceAccount:${module.network_project_prod.build_service_account_email}"
}
