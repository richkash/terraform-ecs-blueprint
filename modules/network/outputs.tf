# output vpc id
output "vpc_id" {
  value = aws_vpc.ecs-vpc.id
}

# output dev subnet ids
output "dev_subnet_ids" {
  value = aws_subnet.dev-subnet[*].id
}

# output qa subnet ids
output "qa_subnet_ids" {
  value = aws_subnet.qa-subnet[*].id
}

# output alb subnet ids
output "alb_subnet_ids" {
  value = aws_subnet.alb-subnet[*].id
}

# output dev security group id
output "ecs_sg_id" {
  value = aws_security_group.ecs-sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}