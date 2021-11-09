output "project_id" {
  value = module.project_factory.project_id
}

output "service_account" {
  value = google_service_account.tf_service_account.email
}