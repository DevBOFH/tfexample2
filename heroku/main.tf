// company.com Infrasturcture

// Configure the Heroku provider
provider "heroku" {
  delays {
    post_app_create_delay    = 15
    post_domain_create_delay = 12
    post_space_create_delay  = 20
  }
}

// Dev Environment
module "company-heroku-dev" {
  source = "./dev"

  heroku_space_name = "company-dev-space"
  heroku_org_name   = "company"
  region            = "oregon"
  app_name          = "company-dev"
  environment       = "dev"
}
