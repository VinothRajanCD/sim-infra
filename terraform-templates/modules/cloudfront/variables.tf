variable "app_name" {
  description = "Name of the project"
}
variable "env_name" {
    description = "name of the environment eg: dev, staging, production."
}  
variable "main_domain_name" {
  description = "Main donain name from the Route 53"
}
variable "lti_alb_domain_name" {
  description = "domain name for the ALB's host header"
}
variable "nv_cf_certificate" {
  description = "ACM certificate for CF"
}
variable "lti_frontend_domain_name" {
  description = "domain name for the frontend host header"
}
variable "s3_static" {
  description = "URL of the S3 bucket"
}
variable "cf_logs_s3_bucket" {
  description = "Store CloudFront logs"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
