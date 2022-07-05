variable "app_name" {
  description = "Name of the Application"
  default     = "sim-gamification"
}
variable "env_name" {
  description = "Environment of the Application"
  default     = "prod"
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
  default     = "10.10.0.0/16"
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
  default     = "prod-lti-alb.sim.crystaldelta.net"
}
variable "lti_frontend_domain_name" {
  description = "Frontend DNS name for LTI"
  default     = "gamification.sim.crystaldelta.net"
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
  default     = 35
}
variable "multi_az" {
  description = "Enabling multi availablity zone"
  default     = true
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
  default = "arn:aws:iam::299005230885:root"
}
variable "accountID" {
  description = "AWS account ID"
  default = "299005230885"
}
variable "IAMUser" {
  description = "IAM user for administrating"
  default = "sim-prod-infra-setup"
}
variable "sns_topic_name" {
  description = "SNS Topic Name."
  default = "SIM-lti-Production-DB-Alert"
}
variable "sns_display_name" {
  description = "SNS Display Name."
  default = "SIM lti Production DB Alert"
}
variable "cpu_utilization_high_alarm_name" {
  description = "The alarm name of the RDS DB CPU utilization high"
  default = "sim_lti_prod_cpu_utilization_high"
}
variable "freeable_memory_low_alarm_name" {
  description = "The alarm name of the RDS DB low memory"
  default = "sim_lti_prod_freeable_memory_low"
}
variable "free_storage_space_low_alarm_name" {
  description = "The alarm name of the RDS DB low storage space"
  default = "sim_lti_prod_free_storage_space_low"
}
variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  default = "sim-lti-prod-lti-db"
}
variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  default = 80
}
variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  default = 209715200
}
variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  default = 5368709120
}