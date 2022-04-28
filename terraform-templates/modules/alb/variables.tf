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
variable "public_subnet_1" {
    description = "Public subnet ID from the VPC"
}
variable "public_subnet_2" {
    description = "Public subnet ID from the VPC"
}
variable "lti_alb_sg" {
    description = "ALB security group ID for LTI ALB"
}
variable "lti_alb_domain_name" {
    description = "domain name for the ALB's host header"
}
variable "nc_acm_certificate" {
    description = "ACM certificate ARN"
}
