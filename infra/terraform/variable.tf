locals {
  cluster_name = "SocialMedia-${random_string.suffix.result}"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR range of the VPC"
}

variable "aws_region" {
  default     = "ap-south-1"
  description = "AWS region"
}

variable "key_name" {
  description = "EC2 Key Pair name for worker nodes"
  type        = string
}
