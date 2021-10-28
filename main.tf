data "google_organization" "lavender_bison" {
  domain = "lavenderbison.com"
}

resource "google_project" "terraform_projects_gcp" {
  name                = "Terraform Projects GCP"
  project_id          = "terraform-projects-gcp"
  org_id              = data.google_organization.placc.org_id
  auto_create_network = false
  billing_account     = var.billing_account_id
}

resource "google_project_service" "compute_api" {
  project = google_project.placc.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "secretmanager_api" {
  project = google_project.placc.project_id
  service = "secretmanager.googleapis.com"
}

resource "google_project_service" "iam_api" {
  project = google_project.placc.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "iamcredentials_api" {
  project = google_project.placc.project_id
  service = "iamcredentials.googleapis.com"
}

resource "google_project_service" "containerregistry_api" {
  project = google_project.placc.project_id
  service = "containerregistry.googleapis.com"
}

resource "google_project_service" "container_api" {
  project = google_project.placc.project_id
  service = "container.googleapis.com"
}

resource "google_project_service" "run_api" {
  project = google_project.placc.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "dns_api" {
  project = google_project.placc.project_id
  service = "dns.googleapis.com"
}

resource "google_project_iam_member" "placc_piper_dougherty" {
  project = google_project.placc.project_id
  role    = "roles/owner"
  member  = "user:doughepi@placc.cloud"
}