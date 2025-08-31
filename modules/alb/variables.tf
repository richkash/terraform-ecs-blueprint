variable "vpc_id" {
    description = "VPC ID where ALB will be deployed"
    type        = string
  
}

variable "alb_subnet_ids" {
    description = "List of subnet IDs for ALB"
    type        = list(string)
  
}

variable "alb_sg_id" {
  description = "ALB security group id"
  type = string
}
