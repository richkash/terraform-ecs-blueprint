# create ALB
resource "aws_lb" "ecs-alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.alb_subnet_ids
  tags = {
    Name = "ecs-alb"
  }
}

# create ALB target group
resource "aws_lb_target_group" "ecs-alb-dev-tg" {
    name     = "ecs-alb-dev-tg"
    port     = 5000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id   = var.vpc_id
    tags = {
      Name = "ALB DEV TG"
    }
}  

# create ALB target group
resource "aws_lb_target_group" "ecs-alb-qa-tg" {
    name     = "ecs-alb-qa-tg"
    port     = 5000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id   = var.vpc_id
    tags = {
      Name = "ALB QA TG"
    }
}

# create ALB Dev listener
resource "aws_lb_listener" "ecs-alb-dev-listener" {
    load_balancer_arn = aws_lb.ecs-alb.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.ecs-alb-dev-tg.arn
    }
    tags = {
      Name = "ALB Dev Listener"
    }
}

resource "aws_lb_listener_rule" "qa" {
  listener_arn = aws_lb_listener.ecs-alb-dev-listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-alb-qa-tg.arn
  }

  condition {
    path_pattern {
      values = ["/qa/*"]
    }
  }
}