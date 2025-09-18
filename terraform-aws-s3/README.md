# AWS S3 Terraform Module

This module creates and manages an AWS Simple Storage Service (S3) bucket with comprehensive configuration options including versioning, encryption, lifecycle policies, CORS, website hosting, notifications, replication, and access controls.

## Features

- ✅ S3 bucket creation with customizable names
- ✅ Bucket versioning with MFA delete support
- ✅ Server-side encryption (SSE-S3, SSE-KMS)
- ✅ Public access block configuration
- ✅ Lifecycle policies for object management
- ✅ CORS configuration for cross-origin requests
- ✅ Static website hosting
- ✅ Access logging
- ✅ Event notifications (Lambda, SQS)
- ✅ Cross-region replication
- ✅ Object lock for compliance
- ✅ Intelligent tiering for cost optimization
- ✅ Inventory and metrics configuration
- ✅ Transfer acceleration
- ✅ Comprehensive tagging

## Usage

### Basic Usage

```hcl
module "s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket = "my-unique-bucket-name"
}
```

### S3 Bucket with Versioning and Encryption

```hcl
module "secure_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket             = "my-secure-bucket"
  versioning_enabled = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
      }
      bucket_key_enabled = true
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "backend-team"
  }
}
```

### S3 Bucket with Lifecycle Policy

```hcl
module "lifecycle_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket = "my-lifecycle-bucket"

  lifecycle_configuration = [
    {
      id     = "delete_old_objects"
      status = "Enabled"

      expiration = {
        days = 90
      }

      noncurrent_version_expiration = {
        noncurrent_days = 30
      }

      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]

      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    }
  ]

  tags = {
    Purpose = "data-archival"
  }
}
```

### Static Website Hosting

```hcl
module "website_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket = "my-website-bucket"
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
      allowed_origins = ["https://example.com"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]

  tags = {
    Type = "website"
  }
}
```

### S3 with Event Notifications

```hcl
module "notification_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket = "my-notification-bucket"

  notification_configuration = {
    lambda_configuration = [
      {
        lambda_function_arn = "arn:aws:lambda:us-west-2:123456789012:function:image-processor"
        events              = ["s3:ObjectCreated:*"]
        filter_prefix       = "uploads/"
        filter_suffix       = ".jpg"
      }
    ]

    sqs_configuration = [
      {
        queue_arn     = "arn:aws:sqs:us-west-2:123456789012:s3-notifications"
        events        = ["s3:ObjectCreated:*"]
        filter_prefix = "documents/"
      }
    ]
  }

  tags = {
    Purpose = "event-driven-processing"
  }
}
```

### Cross-Region Replication

```hcl
module "replicated_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket             = "my-source-bucket"
  versioning_enabled = true

  replication_configuration = {
    role = "arn:aws:iam::123456789012:role/replication-role"

    rules = [
      {
        id     = "replicate_everything"
        status = "Enabled"

        destination = {
          bucket        = "arn:aws:s3:::my-destination-bucket"
          storage_class = "STANDARD_IA"
        }
      }
    ]
  }

  tags = {
    Backup = "cross-region"
  }
}
```

### Object Lock for Compliance

```hcl
module "compliance_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket              = "my-compliance-bucket"
  object_lock_enabled = true

  object_lock_configuration = {
    object_lock_enabled = "Enabled"

    rule = {
      default_retention = {
        mode = "COMPLIANCE"
        days = 365
      }
    }
  }

  tags = {
    Compliance = "required"
    Retention  = "1-year"
  }
}
```

### Advanced Configuration with Multiple Features

```hcl
module "advanced_s3" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-s3?ref=v1.0.0"

  bucket               = "my-advanced-bucket"
  versioning_enabled   = true
  acceleration_status  = "Enabled"
  request_payer        = "Requester"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = false
    }
  }

  intelligent_tiering = [
    {
      name   = "EntireBucket"
      status = "Enabled"

      tiering = [
        {
          access_tier = "DEEP_ARCHIVE_ACCESS"
          days        = 180
        }
      ]
    }
  ]

  logging = {
    target_bucket = "my-access-logs-bucket"
    target_prefix = "access-logs/"
  }

  metric_configuration = [
    {
      name = "EntireBucketMetrics"
    }
  ]

  tags = {
    Environment   = "production"
    Application   = "data-platform"
    CriticalLevel = "high"
    Owner         = "data-team"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket | The name of the S3 bucket | `string` | n/a | yes |
| acl | The canned ACL to apply | `string` | `"private"` | no |
| versioning_enabled | Enable versioning for the S3 bucket | `bool` | `false` | no |
| versioning_mfa_delete | Enable MFA delete for versioning | `bool` | `false` | no |
| lifecycle_configuration | List of lifecycle rules for the bucket | `list(object)` | `[]` | no |
| server_side_encryption_configuration | Server-side encryption configuration | `object` | `null` | no |
| public_access_block | Public access block configuration | `object` | `{block_public_acls=true, block_public_policy=true, ignore_public_acls=true, restrict_public_buckets=true}` | no |
| cors_rule | CORS configuration for the bucket | `list(object)` | `[]` | no |
| website | Website configuration for the bucket | `object` | `null` | no |
| logging | Access logging configuration | `object` | `null` | no |
| notification_configuration | Notification configuration for the bucket | `object` | `null` | no |
| replication_configuration | Replication configuration for the bucket | `object` | `null` | no |
| object_lock_enabled | Enable S3 Object Lock | `bool` | `false` | no |
| object_lock_configuration | Object lock configuration | `object` | `null` | no |
| intelligent_tiering | Intelligent tiering configuration | `list(object)` | `[]` | no |
| inventory_configuration | Inventory configuration for the bucket | `list(object)` | `[]` | no |
| metric_configuration | Metric configuration for the bucket | `list(object)` | `[]` | no |
| request_payer | Specifies who should bear the cost of Amazon S3 data transfer | `string` | `"BucketOwner"` | no |
| tags | A map of tags to assign to the bucket | `map(string)` | `{}` | no |
| force_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| bucket_policy | The JSON policy for the S3 bucket | `string` | `null` | no |
| acceleration_status | Sets the accelerate configuration of an existing bucket | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The name of the bucket |
| bucket_arn | The ARN of the bucket |
| bucket_domain_name | The bucket domain name |
| bucket_regional_domain_name | The bucket region-specific domain name |
| bucket_hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region |
| bucket_region | The AWS region this bucket resides in |
| bucket_website_endpoint | The website endpoint, if the bucket is configured with a website |
| bucket_website_domain | The domain of the website endpoint |
| bucket_versioning_status | The versioning state of the bucket |
| bucket_tags | A map of tags assigned to the bucket |

## Examples

See the `examples/` directory for complete working examples:

- **basic** - Simple S3 bucket with minimal configuration
- **encrypted** - Bucket with KMS encryption and versioning
- **website** - Static website hosting configuration
- **lifecycle** - Advanced lifecycle policies for cost optimization
- **replication** - Cross-region replication setup
- **compliance** - Object lock for regulatory compliance

## License

This module is licensed under the MIT License.