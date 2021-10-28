resource "google_project" "my_project_test" {
  name                = "My Test Project"
  project_id          = "my-mike-project-482410"
  org_id              = var.org_id
  auto_create_network = false
  billing_account     = var.billing_account_id
}