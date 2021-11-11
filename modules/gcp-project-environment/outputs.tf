output "project_id" {
  value = module.project_factory.project_id
}

output "build_service_account_email" {
  value = google_service_account.build_service_account.email
}