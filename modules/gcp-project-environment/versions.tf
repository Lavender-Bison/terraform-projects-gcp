terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.79.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.17.0"
    }
  }
}