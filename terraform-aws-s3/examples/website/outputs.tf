output "bucket_id" {
  description = "The name of the bucket"
  value       = module.website_s3.bucket_id
}

output "bucket_website_endpoint" {
  description = "The website endpoint"
  value       = module.website_s3.bucket_website_endpoint
}

output "bucket_website_domain" {
  description = "The domain of the website endpoint"
  value       = module.website_s3.bucket_website_domain
}