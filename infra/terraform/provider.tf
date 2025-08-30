provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "SocialMedia-${random_string.suffix.result}"
}