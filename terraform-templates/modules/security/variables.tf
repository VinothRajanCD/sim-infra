variable "env_name" {
  description = "Name of the application's environment"
}
variable "app_name" {
  description = "Name of the project"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "vpc_id" {
  description = "VPC id which the security groups are going to launch"
}
variable "lti_service_port" {
  description = "Port which the LTI application is exposed"
}
variable "db_port" {
  description = "Port which the LTI DB is exposed"
}
