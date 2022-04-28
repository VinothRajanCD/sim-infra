variable "app_name" {
  description = "Name of the project"
}
variable "env_name" {
  description = "Name of the application's environment"
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
variable "bastion_ec2_keypair" {
  description = "Bastion ec2 keypair"
}