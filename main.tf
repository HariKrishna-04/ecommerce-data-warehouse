terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "ecommerce-data-warehouse-raw"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ecommerce-tf"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Modules
module "network" {
  source = "./modules/network"

  aws_region    = var.aws_region
  vpc_cidr      = var.vpc_cidr
  cluster_name  = var.cluster_name
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
}

module "redshift" {
  source = "./modules/redshift"

  cluster_name          = var.cluster_name
  master_username       = var.master_username
  master_password       = var.master_password
  database_name         = var.database_name
  node_type             = var.node_type
  number_of_nodes       = var.number_of_nodes
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.redshift_subnet_ids
  security_group_id     = module.network.redshift_security_group_id
  publicly_accessible   = var.publicly_accessible
  iam_role_arn          = module.redshift.redshift_role_arn
  s3_bucket_name        = module.s3.bucket_name
}