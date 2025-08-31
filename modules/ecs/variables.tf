variable "vpc_id" {
  description = "VPC ID where ECS services run"
  type        = string
}

variable "ecs_sg_id" {
  description = "Security group for ECS tasks"
  type        = string
}

variable "dev_subnets" {
  description = "List of private subnets for Dev ECS tasks"
  type        = list(string)
}

variable "qa_subnets" {
  description = "List of private subnets for QA ECS tasks"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ALB listener ARN"
  type        = string
}

variable "alb_tg_dev_arn" {
  description = "Target group ARN for Dev"
  type        = string    
}
variable "alb_tg_qa_arn" {
  description = "Target group ARN for QA"
  type        = string    
}
