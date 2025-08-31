# ECS Dev & QA Environment on AWS with Terraform

This project provisions a complete **AWS Fargate ECS environment** using **Terraform**, with separate **Dev** and **QA** services accessible via an Application Load Balancer (ALB).

The setup is fully automated and modular, covering **networking, load balancing, ECS cluster, task definitions, and Services**.

---

## Project Highlights

- **Infrastructure as Code (IaC)**: Entire AWS environment is defined using Terraform modules.
- **Modular Design**:
  - `network` → VPC, subnets (public + private), IGW, NAT Gateway, security groups.
  - `alb` → Application Load Balancer, listeners, listener rules, target groups.
  - `ecs` → ECS cluster, task definitions, ECS services (Dev & QA), CloudWatch logs.
- **Environment Separation**: 
  - **Dev service** runs in dedicated private subnets.
  - **QA service** runs in separate private subnets.
- **Application Load Balancer Routing**:
  - `http://<alb-dns-name>/` → routes traffic to **Dev ECS service**.
  - `http://<alb-dns-name>/qa/*` → routes traffic to **QA ECS service**.
- **Scalable and Secure**:
  - ECS tasks run on AWS Fargate (serverless).
  - Private subnets for ECS workloads (no direct internet exposure).
  - NAT Gateway for secure outbound internet access (e.g., pulling images from Amazon ECR).

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) v1.x
- AWS account with sufficient IAM privileges
- AWS CLI configured (`aws configure`)
- Docker (to build & push app images to Amazon ECR)