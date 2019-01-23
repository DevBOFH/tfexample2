//variables.tf

variable "heroku_space_name" {
  description = "Heroku Space Name"
}

variable "heroku_org_name" {
  description = "Heroku Organization Name"
}

variable "region" {
  description = "Region to build heroku resources in"
}

variable "app_name" {
  description = "App name to deploy"
}

variable "environment" {
  description = "Environment Name"
}
