resource "aws_alb" "lti_alb" {
  name                       = "${var.app_name}-${var.env_name}-lti-alb"
  subnets                    = [var.public_subnet_1, var.public_subnet_2]
  security_groups            = [var.lti_alb_sg]
  idle_timeout               = 300
  enable_deletion_protection = true

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-alb"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}

resource "aws_lb_target_group" "lti_backend_tg" {
  name     = "sim-${var.env_name}-lti-backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 30
    path                = "/healthCheck"
   }

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-lti-backend-tg"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}

resource "aws_lb_listener" "lti_https_listener" {
  load_balancer_arn = aws_alb.lti_alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.nc_acm_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lti_backend_tg.arn
  }
}

resource "aws_lb_listener_rule" "backend_redirection" {
  listener_arn = aws_lb_listener.lti_https_listener.arn
  priority = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lti_backend_tg.arn
  }

  condition {
    host_header {
     values = [var.lti_alb_domain_name]
   }
  }
}