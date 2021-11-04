variable "app_name" {
  type        = string
  description = "The prefix for the application name."
}

variable "app_env" {
  type        = string
  description = "The environment to be appended to the application name."
}

variable "repo_name" {
  type        = string
  description = "The Github repository this application is defined in."
}

variable "folder_id" {
  type        = string
  description = "The folder the Google Cloud Platform project should be in."
}

variable "org_id" {
  type        = string
  description = "The organization the Google Cloud Platform project should be in."
}

variable "billing_account_id" {
  type        = string
  description = "The billing account ID the Google Cloud Platform project should use."
}

variable "billing_budget" {
  type        = string
  description = "The maximum dollar amount the Google Cloud Platform project should normally consume."
}

variable "activate_apis" {
  type        = list(string)
  description = "The APIs to enable on the Google Cloud Platform project."
}

variable "project_labels" {
  type        = map(string)
  description = "Additional labels to add to the Google Cloud Platform project."
}