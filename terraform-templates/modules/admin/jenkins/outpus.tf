output "jenkins_ec2_sg" {
  value = aws_security_group.jenkins_ec2_sg.id
}
output "jenkins_alb_sg" {
  value = aws_security_group.jenkins_alb_sg.id
}
output "jenkins_tg_id" {
    value = aws_lb_target_group.jenkins_tg
}
output "jenkins_listener_id" {
    value = aws_lb_listener.jenkins_listener
}
output "jenkins_acm_certificate" {
  value = aws_acm_certificate.jenkins_cert.arn
}
output "jenkins_ec2" {
  value = aws_instance.jenkins_ec2_server
}
