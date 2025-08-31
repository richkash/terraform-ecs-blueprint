variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string
}

variable "alb_subnet_cidrs" {
    description = "alb CIDR block"  
    type = list(string)
}

variable "dev_subnet_cidrs" {
    description = "dev CIDR block"  
    type = list(string)
}

variable "qa_subnet_cidrs" {
    description = "qa CIDR block"
    type = list(string)
}

variable "azs" {
    description = "List of availability zones"
    type = list(string)
}
