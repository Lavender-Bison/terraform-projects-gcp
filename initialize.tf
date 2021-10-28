terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.79.0"
    }
  }

  backend "gcs" {
    bucket  = var.state_bucket
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = var.seed_project_id
  region  = "us-central1"
}
