# create ecs cluster
resource "aws_ecs_cluster" "this" {
  name = "ecs-cluster"
  tags = {
    Name = "ecs-cluster"
  }
}

# create IAM role for ecs task execution
resource "aws_iam_role" "ecs_execution" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# attach policy to execute ecs tasks
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# create Dev task definition
resource "aws_ecs_task_definition" "dev" {
  family                   = "flask-app-dev"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "flask-dev"
      image     = "590183909166.dkr.ecr.us-east-1.amazonaws.com/flask-app:latest"
      essential = true
      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
      }]
    }
  ])
}

# create Qa task definition
resource "aws_ecs_task_definition" "qa" {
  family                   = "flask-app-qa"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "flask-qa"
      image     = "590183909166.dkr.ecr.us-east-1.amazonaws.com/flask-app:latest"
      essential = true
      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
      }]
    }
  ])
}

#Dev ECS Service
resource "aws_ecs_service" "dev" {
  name            = "ecs-dev-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.dev.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.dev_subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_tg_dev_arn
    container_name   = "flask-dev"
    container_port   = 5000
  }

  depends_on = [var.alb_listener_arn]
}

#Qa ECS Service
resource "aws_ecs_service" "qa" {
  name            = "ecs-qa-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.qa.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.qa_subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_tg_qa_arn
    container_name   = "flask-qa"
    container_port   = 5000
  }

  depends_on = [var.alb_listener_arn]
}