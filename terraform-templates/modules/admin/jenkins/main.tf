provider "aws" {
  region                   = "us-east-1"
  shared_credentials_file  = "~/.aws/credentials"
  alias                    = "edtech-nonprod"
  profile                  = "your-aws-account-profile-goes-here"
}

resource "aws_security_group" "jenkins_ec2_sg" {
  name        = "${var.app_name}-jenkins-sg"
  description = "allow ec2 to access the alb"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow access to the ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_alb_sg.id]
  }

  ingress {
    description     = "Allow SSH access from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_ec2_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "${var.app_name}-jenkins-sg"
    "Environment" = "${var.app_name}"
    "Application" = var.app_name
  }
}

resource "aws_security_group" "jenkins_alb_sg" {
  name        = "${var.app_name}-jenkins-alb-sg"
  description = "Allow access to the world"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow Jenkins to access from HTTPS port"
    from_port   = 443
    to_port     = 443
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
    "Name"        = "${var.app_name}-jenkins-alb-sg"
    "Environment" = "${var.app_name}"
    "Application" = var.app_name
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins_ec2_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  vpc_security_group_ids      = [aws_security_group.jenkins_ec2_sg.id]
  key_name                    = var.jenkins_ec2_keypair
  subnet_id                   = var.private_subnet
  disable_api_termination     = true
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }
  tags = {
    "Name"        = "sim-jenkins-ec2"
    "Environment" = "${var.app_name}"
    "Application" = var.app_name
  }
}

data "aws_route53_zone" "domain" {
  name     = var.main_domain_name
  provider = aws.edtech-nonprod

}

resource "aws_acm_certificate" "jenkins_cert" {
  domain_name       = var.jenkins_domain_name
  validation_method = "DNS"

  tags = {
    "Name"        = "${var.app_name}-jenkins-acm"
    "Environment" = "${var.app_name}"
    "Application" = var.app_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "jenkins_domain_record" {
  provider = aws.edtech-nonprod
  for_each = {
    for dvo in aws_acm_certificate.jenkins_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate_validation" "jenkins_certificate_validation" {
  certificate_arn         = aws_acm_certificate.jenkins_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.jenkins_domain_record : record.fqdn]
}

resource "aws_alb" "jenkins_alb" {
  name                       = "sim-admin-jenkins-alb"
  subnets                    = [var.public_subnet_1, var.public_subnet_2]
  security_groups            = [aws_security_group.jenkins_alb_sg.id]
  idle_timeout               = 60
  enable_deletion_protection = true

  tags = {
    "Name"        = "${var.app_name}-admin-jenkins-alb"
    "Environment" = "${var.app_name}-admin"
    "Application" = var.app_name
  }
}

resource "aws_lb_target_group" "jenkins_tg" {
  name        = "sim-admin-jenkins-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/login?from=%2F"
  }

  tags = {
    "Name"        = "${var.app_name}-admin-jenkins-tg"
    "Environment" = "${var.app_name}-admin"
    "Application" = var.app_name
  }
}

resource "aws_lb_listener" "jenkins_listener_redirection" {
  load_balancer_arn = aws_alb.jenkins_alb.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_alb.jenkins_alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.jenkins_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
}