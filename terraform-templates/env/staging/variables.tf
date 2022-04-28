variable "app_name" {
  description = "Name of the Application"
  default     = "sim-gamification"
}
variable "env_name" {
  description = "Environment of the Application"
  default     = "stg"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
  default     = "SIM"
}
variable "aws_region" {
  description = "Application's default region"
  default     = "ap-southeast-1"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.1.0.0/16"
}
variable "az_count" {
  description = "Number of availablity zones"
  default     = 2
}
variable "lti_service_port" {
  description = "Port which the LTI application is exposed"
  default     = 9000
}
variable "db_port" {
  description = "Port which the LTI DB is exposed"
  default     = 5432
}
variable "main_domain_name" {
  description = "Main Host name"
  default     = "crystaldelta.net"
}
variable "wildcard_domain_name" {
  description = "Cloudfront domain name"
  default     = "*.sim.crystaldelta.net"
}
variable "lti_alb_domain_name" {
  description = "ALB DNS name for LTI"
  default     = "stg-lti-alb.sim.crystaldelta.net"
}
variable "lti_frontend_domain_name" {
  description = "Frontend DNS name for LTI"
  default     = "gamification-stg.sim.crystaldelta.net"
}
variable "db_instance_class" {
  description = "Instance class of the DB"
  default     = "db.t3.micro"
}
variable "master_user" {
  description = "Mysql DB username"
}
variable "master_password" {
  description = "Mysql DB password"
}
variable "allocated_storage" {
  description = "RDS Allocated Storage"
  default     = 20
}
variable "backup_retention_period" {
  description = "Number of days to backup the DB"
  default     = 7
}
variable "multi_az" {
  description = "Enabling multi availablity zone"
  default     = false
}
variable "fargate_cpu" {
  description = "The number of cpu units used by the task."
  default     = 512
}
variable "fargate_memory" {
  description = "The amount (in MiB) of memory used by the task."
  default     = 1024
}
variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  default     = 1
}
variable "soft_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container."
  default     = 512
}
variable "cluster_count" {
  description = "Redis cluster count"
  default     = 1
}
variable "principal_accounts" {
  description = "Accounts which are making request to this Key"
  default = "arn:aws:iam::176370729502:root"
}
variable "accountID" {
  description = "AWS account ID"
  default = "176370729502"
}
variable "IAMUser" {
  description = "IAM user for administrating"
  default = "sim-stg-infra-setup"
}