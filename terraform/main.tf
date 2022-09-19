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
}

provider "aws" {
  region = "${var.region}"
  default_tags {
    tags = {
      application = local.app_name
    }
  }
}