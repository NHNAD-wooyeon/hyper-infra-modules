module "lifecycle_s3" {
  source = "../../"

  bucket             = "my-lifecycle-bucket-${random_string.suffix.result}"
  versioning_enabled = true

  lifecycle_configuration = [
    {
      id     = "cleanup_old_versions"
      status = "Enabled"

      expiration = {
        days = 365
      }

      noncurrent_version_expiration = {
        noncurrent_days = 90
      }

      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
        {
          days          = 180
          storage_class = "DEEP_ARCHIVE"
        }
      ]

      noncurrent_version_transition = [
        {
          noncurrent_days = 30
          storage_class   = "GLACIER"
        }
      ]

      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    },
    {
      id     = "delete_temp_files"
      status = "Enabled"

      filter = {
        prefix = "temp/"
      }

      expiration = {
        days = 1
      }
    }
  ]

  tags = {
    Environment = "production"
    Example     = "lifecycle"
    Purpose     = "cost-optimization"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}