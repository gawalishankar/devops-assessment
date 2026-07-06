terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix = "devops-assess-prod"
  tags = {
    Environment = "prod"
    Project     = "devops-assessment"
    ManagedBy   = "terraform"
  }
}

module "network" {
  source      = "../../modules/network"
  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
  tags        = local.tags
}

module "ecs" {
  source              = "../../modules/ecs"
  name_prefix         = local.name_prefix
  aws_region          = var.aws_region
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  container_image     = var.container_image
  desired_count        = var.desired_count
  tags                = local.tags
}

module "rds" {
  source                  = "../../modules/rds"
  name_prefix             = local.name_prefix
  vpc_id                  = module.network.vpc_id
  private_subnet_ids      = module.network.private_subnet_ids
  ecs_security_group_id   = module.ecs.ecs_security_group_id
  instance_class          = var.db_instance_class
  db_password             = var.db_password
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  multi_az                = var.multi_az
  tags                    = local.tags
}
