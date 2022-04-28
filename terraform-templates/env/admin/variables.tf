variable "app_name" {
  description = "Name of the Application"
  default     = "sim-gamification"
}
variable "env_name" {
  description = "Environment of the Application"
  default     = "admin"
}
variable "private_subnet" {
  default = "subnet-0f50bd91b35c32386"
}
variable "main_domain_name" {
  default = "crystaldelta.net"
}
variable "jenkins_domain_name" {
  default = "jenkins-gamification.sim.crystaldelta.net"
}
variable "jenkins_ec2_keypair" {
  default = "sim-jenkins-host"
}
variable "bastion_ec2_keypair" {
  default = "sim-bastion-host"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
  default     = "SIM"
}
variable "default_region" {
  description = "Application's default region"
  default     = "ap-southeast-1"
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.5.0.0/16"
}
variable "az_count" {
  description = "Number of availablity zones"
  default     = 2
}
