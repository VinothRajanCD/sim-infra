terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  alias                   = "edtech-nonprod"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "your-aws-account-profile-goes-here"
}

provider "aws" {
  region                  = "us-east-1"
  alias                   = "sim-nonprod"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "your-aws-account-profile-goes-here"
}

provider "aws" {
  region                  = "ap-southeast-1"
  alias                   = "sim-nonprod-singapore"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "your-aws-account-profile-goes-here"
}

data "aws_route53_zone" "domain" {
  name     = var.main_domain_name
  provider = aws.edtech-nonprod
  private_zone = false
}

# Create A Wildcard certificate For SIM CF
resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = var.wildcard_domain_name
  provider          = aws.sim-nonprod
  validation_method = "DNS"

  # subject_alternative_names = [var.wildcard_domain_name]

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-wildcard-acm"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Attach the Wildcard certificate For SIM to Route53
resource "aws_route53_record" "wildcard_domain_record" {
  provider = aws.edtech-nonprod
  for_each = {
    for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => {
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

# Validate Wildcard certificate For SIM CF
resource "aws_acm_certificate_validation" "wildcard_certificate_validation" {
  provider                = aws.sim-nonprod
  certificate_arn         = aws_acm_certificate.wildcard_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_domain_record : record.fqdn]
}

#Create certificate for ALB
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = var.lti_alb_domain_name
  provider          = aws.sim-nonprod-singapore
  validation_method = "DNS"

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-alb-acm"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

#Attach the certificate For SIM ALB to Route53
resource "aws_route53_record" "alb_domain_record" {
  provider = aws.edtech-nonprod
  for_each = {
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options : dvo.domain_name => {
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

#Validate Wildcard certificate For SIM ALB
resource "aws_acm_certificate_validation" "alb_certificate_validation" {
  provider                = aws.sim-nonprod-singapore
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_domain_record : record.fqdn]
}