variable "vpc_id" {
  description = "VPC id which the security groups are going to launch"
}
variable "app_name" {
  description = "Name of the project"
}
variable "env_name" {
  description = "Name of the application's environment"
}
variable "jenkins_ec2_keypair" {
  description = "Jenkins ec2 keypair"
}
variable "jenkins_domain_name" {
  description = "Jenkins domain name"
}
variable "private_subnet" {
  description = "Private subnet ID for the EC2 to launch"
}
variable "public_subnet_1" {
  description = "Public subnet ID from the VPC"
}
variable "public_subnet_2" {
  description = "Public subnet ID from the VPC"
}
variable "main_domain_name" {
  description = "Main donain name from the Route 53"
}
variable "bastion_ec2_sg" {
  description = "Bastion server security group"
}
