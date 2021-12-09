terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.79.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.17.0"
    }
  }

  backend "gcs" {
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

provider "github" {
  token = var.gh_pat
  owner = "Lavender-Bison"
}