provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "your-aws-account-profile-goes-here"
}

terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket         = "sim-gamification-stg-tfstate"
    key            = "sim-infra-setup/terraform-templates/env/admin/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "sim-gamification-stg-tfstate-locks"
    encrypt        = false
  }
}
########################Admin Modules########################
module "vpc" {
  source        = "../../modules/admin/vpc"
  app_name      = var.app_name
  cost_center   = var.cost_center
  vpc_cidr      = var.vpc_cidr
  az_count      = var.az_count
  env_name      = var.env_name
}

module "bastion_server" {
  source              = "../../modules/admin/bastion_server"
  vpc_id              = module.vpc.vpc_id
  public_subnet_1     = module.vpc.public_subnet_1
  public_subnet_2     = module.vpc.public_subnet_2
  bastion_ec2_keypair = var.bastion_ec2_keypair
  app_name            = var.app_name
  env_name            = var.env_name
}

module "jenkins_server" {
  source              = "../../modules/admin/jenkins"
  vpc_id              = module.vpc.vpc_id
  private_subnet      = module.vpc.private_subnet_1
  public_subnet_1     = module.vpc.public_subnet_1
  public_subnet_2     = module.vpc.public_subnet_2
  main_domain_name    = var.main_domain_name
  bastion_ec2_sg      = module.bastion_server.bastion_ec2_sg
  jenkins_ec2_keypair = var.jenkins_ec2_keypair
  jenkins_domain_name = var.jenkins_domain_name
  app_name            = var.app_name
  env_name            = var.env_name
 }