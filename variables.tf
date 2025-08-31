variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string
    default = "10.0.0.0/16"
}

variable "alb_subnet_cidrs" {
    description = "List of public subnet CIDR blocks"
    type        = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "dev_subnet_cidrs" {
    description = "List of public subnet CIDR blocks"
    type        = list(string)
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "qa_subnet_cidrs" {
    description = "List of private subnet CIDR blocks"
    type        = list(string)
    default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}

variable "availability_zones" {
    description = "List of availability zones"
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b"]
}