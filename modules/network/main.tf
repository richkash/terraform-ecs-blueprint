# create VPC 
resource "aws_vpc" "ecs-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ecs-vpc"
  }  
}

# create internet gateway and attach to vpc
resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
    Name = "ecs-igw"
  } 
}

# create public subnets for Alb
resource "aws_subnet" "alb-subnet" {
  count                   = length(var.alb_subnet_cidrs)
  vpc_id                  = aws_vpc.ecs-vpc.id
  cidr_block              = var.alb_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "alb-subnet-${count.index + 1}"
  }
}

# create route table for ALB subnets
resource "aws_route_table" "alb-rt" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
    Name = "alb-rt"
  }
}

# add default route for ALB subnet to internet gateway
resource "aws_route" "alb-rt-default" {
  route_table_id         = aws_route_table.alb-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecs-igw.id
}

# associate route table with ALB subnets
resource "aws_route_table_association" "alb-rt-assoc" {
  count          = length(var.alb_subnet_cidrs)
  subnet_id      = aws_subnet.alb-subnet[count.index].id
  route_table_id = aws_route_table.alb-rt.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "ecs_nat" {
  domain = "vpc"
  tags = {
    Name = "ecs-nat-eip"
  }
}

# NAT Gateway in first ALB subnet (public subnet)
resource "aws_nat_gateway" "ecs_nat" {
  allocation_id = aws_eip.ecs_nat.id
  subnet_id     = aws_subnet.alb-subnet[0].id
  tags = {
    Name = "ecs-nat"
  }
}

# create private subnets for dev
resource "aws_subnet" "dev-subnet" {
  count                   = length(var.dev_subnet_cidrs)
  vpc_id                  = aws_vpc.ecs-vpc.id
  cidr_block              = var.dev_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "dev-subnet-${count.index + 1}"
  }
}

# create private subnets for qa
resource "aws_subnet" "qa-subnet" {
  count                   = length(var.qa_subnet_cidrs)
  vpc_id                  = aws_vpc.ecs-vpc.id
  cidr_block              = var.qa_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "qa-subnet-${count.index + 1}"
  }
}

# Private route table (for Dev + QA subnets)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
    Name = "ecs-private-rt"
  }
}

# Default route via NAT Gateway
resource "aws_route" "private_rt_default" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ecs_nat.id
}

# Associate Dev subnets with private RT
resource "aws_route_table_association" "dev_assoc" {
  count          = length(var.dev_subnet_cidrs)
  subnet_id      = aws_subnet.dev-subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Associate QA subnets with private RT
resource "aws_route_table_association" "qa_assoc" {
  count          = length(var.qa_subnet_cidrs)
  subnet_id      = aws_subnet.qa-subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

################
#security group
################

# create ALB security group
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow inbound traffic on port 80 and 443"
  vpc_id      = aws_vpc.ecs-vpc.id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "alb-sg"
  }
}

# create ecs security group to allow all traffic from ALB security group on port 5000
resource "aws_security_group" "ecs-sg" {
  name        = "ecs-sg"
  description = "Allow all inbound traffic from ALB security group"
  vpc_id      = aws_vpc.ecs-vpc.id
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        # cidr_blocks = ["0.0.0.0/0"]
        security_groups = [aws_security_group.alb-sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "ecs-sg"
  }
}