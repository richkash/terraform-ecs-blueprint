terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# declare the terraform provider
provider "aws" {
  region = "us-east-1"
}

# network module
module "network" {
  source = "./modules/network"
  vpc_cidr = var.vpc_cidr
  dev_subnet_cidrs = var.dev_subnet_cidrs
  qa_subnet_cidrs = var.qa_subnet_cidrs
  alb_subnet_cidrs = var.alb_subnet_cidrs
  azs = var.availability_zones
}

# module alb
module "alb" {
  source = "./modules/alb"
  vpc_id = module.network.vpc_id
  alb_subnet_ids = module.network.alb_subnet_ids
  alb_sg_id = module.network.alb_sg_id
}

# module ecs cluster
module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = module.network.vpc_id
  ecs_sg_id              = module.network.ecs_sg_id
  dev_subnets            = module.network.dev_subnet_ids
  qa_subnets             = module.network.qa_subnet_ids
  alb_listener_arn       = module.alb.listener_arn
  alb_tg_dev_arn         = module.alb.alb_tg_dev_arn
  alb_tg_qa_arn          = module.alb.alb_tg_qa_arn
}