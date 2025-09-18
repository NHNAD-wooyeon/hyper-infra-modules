module "website_s3" {
  source = "../../"

  bucket = "my-website-bucket-${random_string.suffix.result}"
  acl    = "public-read"

  public_access_block = {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["*"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]

  tags = {
    Environment = "development"
    Example     = "website"
    Type        = "static-website"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}