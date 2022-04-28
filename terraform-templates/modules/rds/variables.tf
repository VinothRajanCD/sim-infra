variable "env_name" {
  description = "Name of the application's environment"
}
variable "app_name" {
  description = "Name of the project"
}
variable "cost_center" {
  description = "Name of the application's which will be used to identify the infrastructure cost"
}
variable "db_app_name" {
  description = "Name of the project"
}
variable "db_subnet_1" {
  description = "MySQL DB subnet"
}
variable "db_subnet_2" {
  description = "MySQL DB subnet"
}
variable "db_sg" {
  description = "MySQL DB security group"
}
variable "master_user" {
  description = "MySQL DB root username"
}
variable "master_password" {
  description = "MySQL DB root password"
}
variable "allocated_storage" {
  description = "Size of the RDS DB"
}
variable "db_instance_class" {
  description = "Instance class of the DB"
}
variable "backup_retention_period" {
  description = "Number of days to backup the DB"
}
variable "multi_az" {
  description = "Enabling multi availablity zone"
}
variable "kms_key_arn" {
  description = "KMS key"
}
