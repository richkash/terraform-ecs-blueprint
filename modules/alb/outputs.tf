# output alb dns name
output "alb_dns_name" {
  value = aws_lb.ecs-alb.dns_name
}

# output alb arn
output "alb_arn" {
  value = aws_lb.ecs-alb.arn
}

output "listener_arn" {
  value = aws_lb_listener.ecs-alb-dev-listener.arn
}

# output alb dev target group arn
output "alb_tg_dev_arn" {
  value = aws_lb_target_group.ecs-alb-dev-tg.arn
}

# output alb qa target group arn
output "alb_tg_qa_arn" {
  value = aws_lb_target_group.ecs-alb-qa-tg.arn
}