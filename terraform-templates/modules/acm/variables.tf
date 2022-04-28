variable "env_name" {
  description = "Name of the application's environment"
}
variable "app_name" {
  description = "Name of the project"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "main_domain_name" {
  description = "Main donain name from the Route 53"
}
variable "lti_alb_domain_name" {
  description = "domain name for the ALB's host header"
}
variable "wildcard_domain_name" {
  description = "Cloudfront domain name"
}