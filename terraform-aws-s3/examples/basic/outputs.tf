output "bucket_id" {
  description = "The name of the bucket"
  value       = module.basic_s3.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.basic_s3.bucket_arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.basic_s3.bucket_domain_name
}