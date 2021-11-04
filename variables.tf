variable "gh_pat" {
  type        = string
  description = "The personal access token for performing Github operations."
}

variable "org_id" {
  type        = string
  description = "The organization ID for this Terraform workspace."
}

variable "project_id" {
  type        = string
  description = "The project ID for this Terraform workspace."
}

variable "billing_account_id" {
  type        = string
  description = "The billing account for this Terraform workspace."
}