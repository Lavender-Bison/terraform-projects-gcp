module "example_project_repo" {
  source = "./modules/github-repository"

  // Organization is set up per-provider.
  repo_name = "example-project"
}

module "example_project_dev" {
  source = "./modules/gcp-project-environment"

  app_name           = "example"
  app_env            = "dev"
  repo_name          = module.example_project_repo.repo_name
  org_id             = data.google_organization.lavender_bison.id
  folder_id          = google_folder.dev.id
  billing_account_id = var.billing_account_id
  activate_apis = [
    "compute.googleapis.com"
  ]
  project_labels = {
  }
  billing_budget          = "200"
  state_bucket_project_id = var.project_id
}

module "example_project_qa" {
  source = "./modules/gcp-project-environment"

  app_name           = "example"
  app_env            = "qa"
  repo_name          = module.example_project_repo.repo_name
  org_id             = data.google_organization.lavender_bison.id
  folder_id          = google_folder.qa.id
  billing_account_id = var.billing_account_id
  activate_apis = [
    "compute.googleapis.com"
  ]
  project_labels = {
  }
  billing_budget          = "200"
  state_bucket_project_id = var.project_id
}

module "example_project_prod" {
  source = "./modules/gcp-project-environment"

  app_name           = "example"
  app_env            = "prod"
  repo_name          = module.example_project_repo.repo_name
  org_id             = data.google_organization.lavender_bison.id
  folder_id          = google_folder.prod.id
  billing_account_id = var.billing_account_id
  activate_apis = [
    "compute.googleapis.com"
  ]
  project_labels = {
  }
  billing_budget          = "200"
  state_bucket_project_id = var.project_id
}
