# This file contains the provider configuration for Terraform Cloud.

terraform {
  cloud {
    organization = "my-org"

    workspaces {
      name = "networking-development"
    }
  }
}
