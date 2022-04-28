output "lti_alb_id" {
    value = aws_alb.lti_alb.id
}
output "lti_backend_tg_id" {
    value = aws_lb_target_group.lti_backend_tg
}
output "lti_https_listener_id" {
    value = aws_lb_listener.lti_https_listener
}