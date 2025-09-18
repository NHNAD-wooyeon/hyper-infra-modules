variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply"
  type        = string
  default     = "private"
  validation {
    condition = contains([
      "private", "public-read", "public-read-write", "aws-exec-read",
      "authenticated-read", "bucket-owner-read", "bucket-owner-full-control"
    ], var.acl)
    error_message = "ACL must be a valid canned ACL."
  }
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "versioning_mfa_delete" {
  description = "Enable MFA delete for versioning"
  type        = bool
  default     = false
}

variable "lifecycle_configuration" {
  description = "List of lifecycle rules for the bucket"
  type = list(object({
    id     = string
    status = string
    filter = optional(object({
      prefix                   = optional(string)
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      tags                     = optional(map(string))
    }))
    expiration = optional(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    }))
    noncurrent_version_expiration = optional(object({
      noncurrent_days           = optional(number)
      newer_noncurrent_versions = optional(number)
    }))
    transition = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })))
    noncurrent_version_transition = optional(list(object({
      noncurrent_days           = optional(number)
      newer_noncurrent_versions = optional(number)
      storage_class             = string
    })))
    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
  }))
  default = []
}

variable "server_side_encryption_configuration" {
  description = "Server-side encryption configuration"
  type = object({
    rule = object({
      apply_server_side_encryption_by_default = object({
        sse_algorithm     = string
        kms_master_key_id = optional(string)
      })
      bucket_key_enabled = optional(bool)
    })
  })
  default = null
}

variable "public_access_block" {
  description = "Public access block configuration"
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "cors_rule" {
  description = "CORS configuration for the bucket"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "website" {
  description = "Website configuration for the bucket"
  type = object({
    index_document           = optional(string)
    error_document           = optional(string)
    redirect_all_requests_to = optional(string)
    routing_rules            = optional(string)
  })
  default = null
}

variable "logging" {
  description = "Access logging configuration"
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = null
}

variable "notification_configuration" {
  description = "Notification configuration for the bucket"
  type = object({
    cloudwatch_configuration = optional(list(object({
      id            = optional(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })))
    lambda_configuration = optional(list(object({
      id                  = optional(string)
      lambda_function_arn = string
      events              = list(string)
      filter_prefix       = optional(string)
      filter_suffix       = optional(string)
    })))
    sqs_configuration = optional(list(object({
      id            = optional(string)
      queue_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })))
  })
  default = null
}

variable "replication_configuration" {
  description = "Replication configuration for the bucket"
  type = object({
    role = string
    rules = list(object({
      id       = string
      status   = string
      priority = optional(number)
      prefix   = optional(string)
      filter = optional(object({
        prefix = optional(string)
        tags   = optional(map(string))
      }))
      destination = object({
        bucket             = string
        storage_class      = optional(string)
        replica_kms_key_id = optional(string)
        access_control_translation = optional(object({
          owner = string
        }))
        account_id = optional(string)
        metrics = optional(object({
          status = string
          event_threshold = optional(object({
            minutes = number
          }))
        }))
        replication_time = optional(object({
          status = string
          time = object({
            minutes = number
          })
        }))
      })
      delete_marker_replication = optional(object({
        status = string
      }))
      existing_object_replication = optional(object({
        status = string
      }))
    }))
  })
  default = null
}

variable "object_lock_enabled" {
  description = "Enable S3 Object Lock"
  type        = bool
  default     = false
}

variable "object_lock_configuration" {
  description = "Object lock configuration"
  type = object({
    object_lock_enabled = string
    rule = optional(object({
      default_retention = object({
        mode  = string
        days  = optional(number)
        years = optional(number)
      })
    }))
  })
  default = null
}

variable "intelligent_tiering" {
  description = "Intelligent tiering configuration"
  type = list(object({
    name   = string
    status = string
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    tiering = list(object({
      access_tier = string
      days        = number
    }))
  }))
  default = []
}

variable "inventory_configuration" {
  description = "Inventory configuration for the bucket"
  type = list(object({
    name                     = string
    included_object_versions = string
    schedule = object({
      frequency = string
    })
    destination = object({
      bucket = object({
        format     = string
        bucket_arn = string
        prefix     = optional(string)
        account_id = optional(string)
        encryption = optional(object({
          sse_kms = optional(object({
            key_id = string
          }))
          sse_s3 = optional(object({}))
        }))
      })
    })
    filter = optional(object({
      prefix = optional(string)
    }))
    optional_fields = optional(list(string))
  }))
  default = []
}

variable "metric_configuration" {
  description = "Metric configuration for the bucket"
  type = list(object({
    name = string
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
  }))
  default = []
}

variable "request_payer" {
  description = "Specifies who should bear the cost of Amazon S3 data transfer"
  type        = string
  default     = "BucketOwner"
  validation {
    condition     = contains(["Requester", "BucketOwner"], var.request_payer)
    error_message = "Request payer must be either 'Requester' or 'BucketOwner'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "bucket_policy" {
  description = "The JSON policy for the S3 bucket"
  type        = string
  default     = null
}

variable "acceleration_status" {
  description = "Sets the accelerate configuration of an existing bucket"
  type        = string
  default     = null
  validation {
    condition     = var.acceleration_status == null || contains(["Enabled", "Suspended"], var.acceleration_status)
    error_message = "Acceleration status must be either 'Enabled' or 'Suspended'."
  }
}