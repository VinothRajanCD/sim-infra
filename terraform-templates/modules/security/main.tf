#Security Group for SIM LTI ALB
resource "aws_security_group" "lti_alb_sg" {
  name        = "${var.app_name}-${var.env_name}-lti-alb-sg"
  description = "Allow traffic from the internet to LTI app"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-alb-sg"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}

#Security Group for SIM LTI ECS Fargate application
resource "aws_security_group" "lti_app_sg" {
  name        = "${var.app_name}-${var.env_name}-lti-app-sg"
  description = "Forwards traffic to LTI ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ALB to access service"
    from_port       = var.lti_service_port
    to_port         = var.lti_service_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lti_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-app-sg"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}

#Security Group for SIM LTI PostgreSQL DB
resource "aws_security_group" "lti_rds_sg" {
  name        = "${var.app_name}-${var.env_name}-lti-rds-sg"
  description = "Security group for LTI Database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ECS access"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lti_app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-rds-sg"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}