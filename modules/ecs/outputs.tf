output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "dev_service_name" {
  value = aws_ecs_service.dev.name
}

# output "qa_service_name" {
#   value = aws_ecs_service.qa.name
# }
