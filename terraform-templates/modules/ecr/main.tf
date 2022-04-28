resource "aws_ecr_repository" "lti_ecr" {
  name = "sim-lti-${var.env_name}-lti-ecr"

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-ecr"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}