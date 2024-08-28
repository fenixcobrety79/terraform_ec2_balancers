terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"  # Cambia la región según tu preferencia
}

# resource "aws_s3_bucket" "example_bucket" {
#   count = local.rg_no
#   bucket = "rg_${count.index}"   # El nombre debe ser único en S3
  
# }

# variable "nombre" {
#   type = string
#   description = "nombre del s3"
# }

# variable "rg_count"{
#   type = number

# }

# locals {
#   min_rg_number = 3
#   rg_no = var.rg_count > 0 ? var.rg_count : local.min_rg_number
#   }



variable "vpc_id" {
  description = "The ID of the VPC"
  default = "vpc-0271f4c461297d768"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "selected" {
  count = length(data.aws_subnets.selected.ids)
  id    = element(data.aws_subnets.selected.ids, count.index)
}

output "vpc_cidr_block" {
  value = data.aws_vpc.selected.cidr_block
}

output "subnet_ids" {
  value = data.aws_subnets.selected.ids
}

output "subnet_cidr_blocks" {
  value = [for subnet in data.aws_subnet.selected : subnet.cidr_block]
}