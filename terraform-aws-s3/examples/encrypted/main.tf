module "encrypted_s3" {
  source = "../../"

  bucket             = "my-encrypted-bucket-${random_string.suffix.result}"
  versioning_enabled = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = false
    }
  }

  tags = {
    Environment = "production"
    Example     = "encrypted"
    Encrypted   = "true"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}