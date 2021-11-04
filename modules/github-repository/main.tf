resource "github_repository" "github_repository" {
  name       = var.repo_name
  visibility = "private"
}