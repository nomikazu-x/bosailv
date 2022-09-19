terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.1.0"
    }
  }
}

locals {
  app_name = "bosailv"
  host_domain = "bosailv.com"
  app_domain_name = "app.bosailv.com"
  api_domain_name = "api.bosailv.com"
  ssm_parameter_store_base = "/bosailv/prod"
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      application = local.app_name
    }
  }
}