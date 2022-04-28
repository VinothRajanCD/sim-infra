variable "env_name" {
  description = "Name of the application's environment"
}
variable "app_name" {
  description = "Name of the project"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "vpc_cidr" {
  description = "VPC CIDR value"
}
variable "az_count" {
  description = "Number of availablity zones"
}