resource "aws_ecs_cluster" "app_cluster" {
  name = "${var.app_name}-${var.env_name}-cluster"

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-cluster"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}

resource "aws_ecs_task_definition" "lti" {
  family                   = "${var.app_name}-${var.env_name}-lti"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.task_execution_role_arn
  container_definitions    = <<DEFINITION
    [
      {
        "name":"${var.app_name}-${var.env_name}-lti",
        "memory_reservation": "${var.soft_memory_reservation}",
        "image":"${var.lti_ecr}:${var.tag}",
        "logConfiguration":{
            "logDriver":"awslogs",
            "options":{
              "awslogs-group":"${var.lti_logs}",
              "awslogs-region":"${var.aws_region}",
              "awslogs-stream-prefix":"ecs"
            }
        },
        "portMappings":[
            {
              "containerPort":${var.lti_service_port},
              "hostPort":${var.lti_service_port},
              "protocol":"tcp"
            }
        ],
        "essential":true,
        "secrets": [
          {
            "name": "DB_USERNAME",
            "valueFrom": "${var.lti_secret_manager_arn}:DB_USERNAME::"
          },
          {
            "name": "DB_PASSWORD",
            "valueFrom": "${var.lti_secret_manager_arn}:DB_PASSWORD::"
          },
          {
            "name": "DB_NAME",
            "valueFrom": "${var.lti_secret_manager_arn}:DB_NAME::"
          },
          {
            "name": "DB_HOST",
            "valueFrom": "${var.lti_secret_manager_arn}:DB_HOST::"
          },
          {
            "name": "PORT",
            "valueFrom": "${var.lti_secret_manager_arn}:PORT::"
          },
          {
            "name": "HOST_URL",
            "valueFrom": "${var.lti_secret_manager_arn}:HOST_URL::"
          },
          {
            "name": "AUTHORIZATION",
            "valueFrom": "${var.lti_secret_manager_arn}:AUTHORIZATION::"
          },
          {
            "name": "PUBLIC_JWK",
            "valueFrom": "${var.lti_secret_manager_arn}:PUBLIC_JWK::"
          },
          {
            "name": "TOKEN_ENDPOINT",
            "valueFrom": "${var.lti_secret_manager_arn}:TOKEN_ENDPOINT::"
          },
           {
            "name": "LTI_CLIENT_SECRET",
            "valueFrom": "${var.lti_secret_manager_arn}:LTI_CLIENT_SECRET::"
          },
          {
            "name": "LTI_CLIENT_ID",
            "valueFrom": "${var.lti_secret_manager_arn}:LTI_CLIENT_ID::"
          },
          {
            "name": "TARGET_URI",
            "valueFrom": "${var.lti_secret_manager_arn}:TARGET_URI::"
          },
          {
            "name": "OAUTH_LOGIN",
            "valueFrom": "${var.lti_secret_manager_arn}:OAUTH_LOGIN::"
          },
          {
            "name": "LTI_REDIRECT_URI",
            "valueFrom": "${var.lti_secret_manager_arn}:LTI_REDIRECT_URI::"
          },
          {
            "name": "TOKEN_REDIRECT",
            "valueFrom": "${var.lti_secret_manager_arn}:TOKEN_REDIRECT::"
          },
          {
            "name": "CANVAS_INSTANCE_HOST_URL",
            "valueFrom": "${var.lti_secret_manager_arn}:CANVAS_INSTANCE_HOST_URL::"
          },
          {
            "name": "SESSION_SECRET",
            "valueFrom": "${var.lti_secret_manager_arn}:SESSION_SECRET::"
          },
          {
            "name": "LTI_FRONTEND_URL",
            "valueFrom": "${var.lti_secret_manager_arn}:LTI_FRONTEND_URL::"
          },
          {
            "name": "ACCESS_TOKEN",
            "valueFrom": "${var.lti_secret_manager_arn}:ACCESS_TOKEN::"
          },
          {
            "name": "API_CLIENT_SECRET",
            "valueFrom": "${var.lti_secret_manager_arn}:API_CLIENT_SECRET::"
          },
          {
            "name": "API_CLIENT_ID",
            "valueFrom": "${var.lti_secret_manager_arn}:API_CLIENT_ID::"
          },
          {
            "name": "DB_DIALECT",
            "valueFrom": "${var.lti_secret_manager_arn}:DB_DIALECT::"
          }
        ]
      }
  ]
  DEFINITION
}

resource "aws_ecs_service" "lti" {
  name            = "${var.app_name}-${var.env_name}-lti-service"
  depends_on      = [var.ecs_policy]
  cluster         = aws_ecs_cluster.app_cluster.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.lti.arn

  load_balancer {
    target_group_arn = var.lti_backend_tg_id
    container_name   = "${var.app_name}-${var.env_name}-lti"
    container_port   = var.lti_service_port
  }

  network_configuration {
    security_groups = [var.lti_app_sg]
    subnets         = [var.private_subnet_1, var.private_subnet_2]
  }
}
