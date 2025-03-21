# This file contains the provider configuration for Terraform Cloud, add it to your existing provider configuretion (dont replace)

terraform {
  cloud {
    organization = "my-org"

    workspaces {
      name = "networking-development"
    }
  }
}
