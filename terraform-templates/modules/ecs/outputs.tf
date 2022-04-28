# output "ecs_cluster" {
#   value = aws_ecs_cluster.app_cluster.arn
# }
output "lti_task_definition" {
  value = aws_ecs_task_definition.lti
}
output "lti_service" {
  value = aws_ecs_service.lti
}