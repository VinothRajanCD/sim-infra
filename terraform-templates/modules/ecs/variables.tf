variable "env_name" {
  description = "Name of the application's environment"
}
variable "app_name" {
  description = "Name of the project"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "fargate_cpu" {
  description = "The number of cpu units used by the task."
}
variable "fargate_memory" {
  description = "The amount (in MiB) of memory used by the task."
}
variable "task_execution_role_arn" {
  description = "IAM task execution role"
}
variable "soft_memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container."
}
variable "lti_ecr" {
  description = "ECR image arn for LTI task definition."
}
# variable "app_cluster" {
#   description = "ECS Cluster"
# }
variable "tag" {
  description = "ECR image tag"
  default     = "latest"
}
variable "lti_logs" {
  description = "LTI cloudwatch logs."
}
variable "aws_region" {
  description = "Cloudwatch log region."
}
variable "lti_secret_manager_arn" {
  description = "Secret Manager ARN"
}
variable "ecs_policy" {
  description = "ECS IAM policy."
}
variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
}
variable "lti_backend_tg_id" {
  description = "LTI target group ID for LTI"
}
variable "lti_service_port" {
  description = "Port which the LTI application is exposed"
}
variable "lti_app_sg" {
  description = "Application security group."
}
variable "private_subnet_1" {
  description = "Private subnet ID for the ECS service"
}
variable "private_subnet_2" {
  description = "Private subnet ID for the ECS service"
}