output "wildcard_acm_certificate" {
  value = aws_acm_certificate.wildcard_cert.arn
}
output "alb_acm_certificate" {
  value = aws_acm_certificate.alb_cert.arn
}