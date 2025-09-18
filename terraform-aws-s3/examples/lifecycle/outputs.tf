output "bucket_id" {
  description = "The name of the bucket"
  value       = module.lifecycle_s3.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.lifecycle_s3.bucket_arn
}

output "bucket_versioning_status" {
  description = "The versioning state of the bucket"
  value       = module.lifecycle_s3.bucket_versioning_status
}