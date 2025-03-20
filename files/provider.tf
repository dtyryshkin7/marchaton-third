# This file contains the provider configuration for Terraform Cloud.

terraform {
  cloud {
    organization = "my-org"

    workspaces {
      project = "networking-development"
    }
  }
}
