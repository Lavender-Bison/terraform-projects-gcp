resource "github_repository" "example" {
  name        = var.repo_name
  description = "My awesome codebase"

  visibility = "private"
}