data "google_organization" "lavender_bison" {
  domain = "lavenderbison.com"
}

resource "google_project" "terraform_projects_gcp" {
  name                = "My Test Project"
  project_id          = "my-test-project-482410"
  org_id              = var.org_id
  auto_create_network = false
  billing_account     = var.billing_account_id
}
