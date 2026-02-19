# Container Python API, Kafka, Lambda consumer, via Terraform + CloudFormation
# github.com/sqlxpert/docker-python-openapi-kafka-terraform-cloudformation-aws
# GPLv3, Copyright Paul Marcelin

output "hello_api_aws_ecr_registry_region" {
  value       = aws_ecr_repository.hello[local.ecr_repository_name].region
  description = "AWS region code for hello_api Elastic Container Registry"
  sensitive   = false
  ephemeral   = false
}

output "hello_api_aws_ecr_registry_uri" {
  value       = split("/", aws_ecr_repository.hello[local.ecr_repository_name].repository_url)[0]
  description = "URI of hello_api Elastic Container Registry"
  sensitive   = false
  ephemeral   = false
}

output "hello_api_aws_ecr_repository_url" {
  value       = aws_ecr_repository.hello[local.ecr_repository_name].repository_url
  description = "URL of hello_api Elastic Container Registry repository"
  sensitive   = false
  ephemeral   = false
}

output "hello_api_image_tag" {
  value       = var.hello_api_image_tag
  description = "Version tag of hello_api image in Elastic Container Registry repository"
  sensitive   = false
  ephemeral   = false
}

output "hello_api_load_balander_domain_name" {
  value       = try(aws_lb.hello_api[0].dns_name, "NOT_ENABLED")
  description = "Domain name (on the public Internet) of the hello_api load balancer. Use this to connect. If create_vpc is false , this will read NOT_ENABLED ."
  sensitive   = false
  ephemeral   = false
}

output "base_amazonlinux_tag" {
  value       = var.base_amazonlinux_tag
  description = "Version of the Amazon Linux base image. See https://docs.aws.amazon.com/linux/al2023/ug/base-container.html , https://gallery.ecr.aws/amazonlinux/amazonlinux , and https://github.com/amazonlinux/container-images/blob/al2023/Dockerfile"
  sensitive   = false
  ephemeral   = false
}

output "base_amazonlinux_digest" {
  value       = var.base_amazonlinux_digest
  description = "Digest of the Amazon Linux base image. See https://github.com/amazonlinux/container-images/blob/al2023/Dockerfile"
  sensitive   = false
  ephemeral   = false
}
