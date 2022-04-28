resource "aws_cloudwatch_log_group" "lti_logs" {
  name = "${var.app_name}-${var.env_name}-lti-logs"
  retention_in_days = 14

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-logs"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}
