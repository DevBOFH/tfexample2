// company Dev Heroku Environment
// main.tf

// Create a Private Space on Heroku
resource "heroku_space" "dev" {
  name         = "${var.heroku_space_name}"
  organization = "${var.heroku_org_name}"
  region       = "${var.region}"
}

// Only allow traffic from the company.com Office Egress
resource "heroku_space_inbound_ruleset" "default" {
  space      = "${heroku_space.dev.name}"
  depends_on = ["heroku_space.dev"]

  rule {
    action = "allow"
    source = "98.152.9.242/32"
  }
}

resource "heroku_app" "company-dev" {
  name       = "${var.app_name}"
  region     = "${var.region}"
  space      = "${heroku_space.dev.name}"
  depends_on = ["heroku_space.dev"]

  config_vars {
    APP_ENV = "${var.environment}"
  }

  buildpacks = [
    "https://github.com/DataDog/heroku-buildpack-datadog.git",
    "https://github.com/heroku/heroku-buildpack-pgbouncer.git",
    "https://github.com/andrewychoi/heroku-buildpack-scipy",
    "https://github.com/dscout/wkhtmltopdf-buildpack.git",
  ]
}

resource "heroku_addon" "cloudamqp" {
  app        = "${var.app_name}"
  plan       = "cloudamqp:tiger"
  depends_on = ["heroku_app.company-dev"]
}

resource "heroku_addon" "heroku-postgresql" {
  app        = "${var.app_name}"
  plan       = "heroku-postgresql:standard-2"
  depends_on = ["heroku_app.company-dev"]
}

resource "heroku_addon" "memcachier" {
  app        = "${var.app_name}"
  plan       = "memcachier:dev"
  depends_on = ["heroku_app.company-dev"]
}

resource "heroku_addon" "newrelic" {
  app        = "${var.app_name}"
  plan       = "newrelic:wayne"
  depends_on = ["heroku_app.company-dev"]
}

resource "heroku_addon" "scheduler" {
  app        = "${var.app_name}"
  plan       = "scheduler:standard"
  depends_on = ["heroku_app.company-dev"]
}

// Log Drains
resource "heroku_drain" "datadog" {
  app        = "${var.app_name}"
  depends_on = ["heroku_app.company-dev"]
  url        = "https://http-intake.logs.datadoghq.com/v1/input/d07eae16e53ef55f3738edfde13d7200?ddsource=heroku&service=company-private-dev&host=company-private-dev"
}
