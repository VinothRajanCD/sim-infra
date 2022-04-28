output "lti_alb_sg" {
  value = aws_security_group.lti_alb_sg.id
}
output "lti_app_sg" {
  value = aws_security_group.lti_app_sg.id
}
output "lti_rds_sg" {
  value = aws_security_group.lti_rds_sg.id
}