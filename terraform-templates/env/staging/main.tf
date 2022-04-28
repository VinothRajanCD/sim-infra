terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15"
    }
  }
}

provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "your-aws-account-profile-goes-here"
}

# S3 bUCKET FOR STORING THE TERRAFORM STATE
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "sim-gamification-stg-tfstate"
#   versioning {
#     enabled = true
#   }
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }

#DINAMODB TABLE FOR LOCKING THR TERRAFORM
# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "sim-gamification-stg-tfstate-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"  
  
# attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket         = "sim-gamification-stg-tfstate"
    key            = "sim-infra-setup/terraform-templates/env/staging/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "sim-gamification-stg-tfstate-locks"
    encrypt        = false
  }
}

########################Modules########################
module "vpc" {
  source        = "../../modules/vpc"
  app_name      = var.app_name
  cost_center   = var.cost_center
  vpc_cidr      = var.vpc_cidr
  az_count      = var.az_count
  env_name      = var.env_name
}

module "security" {
  source            = "../../modules/security"
  app_name          = var.app_name
  cost_center       = var.cost_center
  vpc_id            = module.vpc.vpc_id
  lti_service_port  = var.lti_service_port
  db_port           = var.db_port
  env_name          = var.env_name
}

module "acm" {
  source               = "../../modules/acm"
  app_name             = var.app_name
  cost_center          = var.cost_center
  main_domain_name     = var.main_domain_name
  wildcard_domain_name = var.wildcard_domain_name
  lti_alb_domain_name  = var.lti_alb_domain_name
  env_name             = var.env_name
}

module "alb" {
  source                  = "../../modules/alb"
  app_name                = var.app_name
  cost_center             = var.cost_center
  vpc_id                  = module.vpc.vpc_id
  public_subnet_1         = module.vpc.public_subnet_1
  public_subnet_2         = module.vpc.public_subnet_2
  lti_alb_sg              = module.security.lti_alb_sg
  nc_acm_certificate      = module.acm.alb_acm_certificate
  lti_alb_domain_name     = var.lti_alb_domain_name
  env_name                = var.env_name
}

module "ecr" {
  source   = "../../modules/ecr"
  app_name       = var.app_name
  cost_center    = var.cost_center
  env_name       = var.env_name
}

module "secret_manager" {
  source = "../../modules/secret_manager"
  app_name                = var.app_name
  cost_center             = var.cost_center
  env_name                = var.env_name
}

module "iam" {
  source             = "../../modules/iam"
  app_name           = var.app_name
  cost_center        = var.cost_center
  secret_manager_arn = module.secret_manager.lti_secret_manager_arn.arn
  env_name           = var.env_name
}

module "kms" {
  source                  = "../../modules/kms"
  app_name                = var.app_name
  env_name                = var.env_name
  cost_center             = var.cost_center
  principal_accounts      = var.principal_accounts
  accountID               = var.accountID
  IAMUser                 = var.IAMUser
}

module "rds" {
  source                  = "../../modules/rds"
  app_name                = var.app_name
  cost_center             = var.cost_center
  db_instance_class       = var.db_instance_class
  db_app_name             = var.app_name
  db_subnet_1             = module.vpc.db_subnet_1
  db_subnet_2             = module.vpc.db_subnet_2
  db_sg                   = module.security.lti_rds_sg
  master_user             = var.master_user
  master_password         = var.master_password
  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  env_name                = var.env_name
  kms_key_arn             = module.kms.rds_kms_key_arn
}

module "cloudwatch" {
  source   = "../../modules/cloudwatch"
  app_name      = var.app_name
  cost_center   = var.cost_center
  env_name      = var.env_name
}

module "s3" {
  source              = "../../modules/s3"
  env_name            = var.env_name
  app_name            = var.app_name
}

module "cloudfront" {
  source                    = "../../modules/cloudfront"
  env_name                  = var.env_name
  app_name                  = var.app_name
  s3_static                 = module.s3.s3_frontend
  nv_cf_certificate         = module.acm.wildcard_acm_certificate
  lti_frontend_domain_name  = var.lti_frontend_domain_name
  lti_alb_domain_name       = var.lti_alb_domain_name
  main_domain_name          = var.main_domain_name
  cf_logs_s3_bucket         = module.s3.cf_logs_s3_bucket.id
  cost_center               = var.cost_center
} 

module "ecs" {
  source                  = "../../modules/ecs"
  app_name                = var.app_name
  cost_center             = var.cost_center
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  desired_count           = var.desired_count
  soft_memory_reservation = var.soft_memory_reservation
  lti_service_port        = var.lti_service_port
  aws_region              = var.aws_region
  task_execution_role_arn = module.iam.task_execution_role.arn
  lti_ecr                 = module.ecr.lti_ecr.repository_url
  lti_logs                = module.cloudwatch.lti_logs
  ecs_policy              = module.iam.ecs_policy
  lti_backend_tg_id       = module.alb.lti_backend_tg_id.arn
  lti_app_sg              = module.security.lti_app_sg
  private_subnet_1        = module.vpc.private_subnet_1
  private_subnet_2        = module.vpc.private_subnet_2
  lti_secret_manager_arn  = module.secret_manager.lti_secret_manager_arn.arn
  env_name                = var.env_name
}