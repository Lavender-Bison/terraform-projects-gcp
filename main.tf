data "google_organization" "lavender_bison" {
  domain = "lavenderbison.com"
}

resource "google_folder" "dev" {
  display_name = "dev"
  parent       = data.google_organization.lavender_bison.name
}

resource "google_folder" "qa" {
  display_name = "qa"
  parent       = data.google_organization.lavender_bison.name
}

resource "google_folder" "prod" {
  display_name = "prod"
  parent       = data.google_organization.lavender_bison.name
}