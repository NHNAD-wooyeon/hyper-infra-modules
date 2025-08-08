output "repository_url" {
  description = "The URL of the ECR repository"
  value       = module.basic_ecr.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = module.basic_ecr.repository_arn
}