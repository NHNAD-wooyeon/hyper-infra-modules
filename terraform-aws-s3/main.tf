resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
  force_destroy = var.force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_acl" "this" {
  count      = var.acl != null ? 1 : 0
  bucket     = aws_s3_bucket.this.id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status     = var.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = var.versioning_mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.server_side_encryption_configuration != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm
      kms_master_key_id = var.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id
    }
    bucket_key_enabled = var.server_side_encryption_configuration.rule.bucket_key_enabled
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.public_access_block != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_block.block_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_configuration) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_configuration
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "filter" {
        for_each = rule.value.filter != null ? [rule.value.filter] : []
        content {
          and {
            prefix                   = filter.value.prefix
            object_size_greater_than = filter.value.object_size_greater_than
            object_size_less_than    = filter.value.object_size_less_than
            tags                     = filter.value.tags
          }
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days                         = expiration.value.days
          date                         = expiration.value.date
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
          newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition != null ? rule.value.transition : []
        content {
          days          = transition.value.days
          date          = transition.value.date
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition != null ? rule.value.noncurrent_version_transition : []
        content {
          noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
          newer_noncurrent_versions = noncurrent_version_transition.value.newer_noncurrent_versions
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload != null ? [rule.value.abort_incomplete_multipart_upload] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_rule) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.website != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "index_document" {
    for_each = var.website.index_document != null ? [var.website.index_document] : []
    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = var.website.error_document != null ? [var.website.error_document] : []
    content {
      key = error_document.value
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = var.website.redirect_all_requests_to != null ? [var.website.redirect_all_requests_to] : []
    content {
      host_name = redirect_all_requests_to.value
    }
  }

  routing_rules = var.website.routing_rules
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.logging != null ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix
}

resource "aws_s3_bucket_notification" "this" {
  count  = var.notification_configuration != null ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "cloudwatch_configuration" {
    for_each = var.notification_configuration.cloudwatch_configuration != null ? var.notification_configuration.cloudwatch_configuration : []
    content {
      id            = cloudwatch_configuration.value.id
      filter_prefix = cloudwatch_configuration.value.filter_prefix
      filter_suffix = cloudwatch_configuration.value.filter_suffix
    }
  }

  dynamic "lambda_function" {
    for_each = var.notification_configuration.lambda_configuration != null ? var.notification_configuration.lambda_configuration : []
    content {
      id                  = lambda_function.value.id
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  dynamic "queue" {
    for_each = var.notification_configuration.sqs_configuration != null ? var.notification_configuration.sqs_configuration : []
    content {
      id            = queue.value.id
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count  = var.replication_configuration != null ? 1 : 0
  role   = var.replication_configuration.role
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.replication_configuration.rules
    content {
      id       = rule.value.id
      status   = rule.value.status
      priority = rule.value.priority
      prefix   = rule.value.prefix

      dynamic "filter" {
        for_each = rule.value.filter != null ? [rule.value.filter] : []
        content {
          prefix = filter.value.prefix
          tags   = filter.value.tags
        }
      }

      destination {
        bucket             = rule.value.destination.bucket
        storage_class      = rule.value.destination.storage_class
        replica_kms_key_id = rule.value.destination.replica_kms_key_id

        dynamic "access_control_translation" {
          for_each = rule.value.destination.access_control_translation != null ? [rule.value.destination.access_control_translation] : []
          content {
            owner = access_control_translation.value.owner
          }
        }

        account_id = rule.value.destination.account_id

        dynamic "metrics" {
          for_each = rule.value.destination.metrics != null ? [rule.value.destination.metrics] : []
          content {
            status = metrics.value.status
            dynamic "event_threshold" {
              for_each = metrics.value.event_threshold != null ? [metrics.value.event_threshold] : []
              content {
                minutes = event_threshold.value.minutes
              }
            }
          }
        }

        dynamic "replication_time" {
          for_each = rule.value.destination.replication_time != null ? [rule.value.destination.replication_time] : []
          content {
            status = replication_time.value.status
            time {
              minutes = replication_time.value.time.minutes
            }
          }
        }
      }

      dynamic "delete_marker_replication" {
        for_each = rule.value.delete_marker_replication != null ? [rule.value.delete_marker_replication] : []
        content {
          status = delete_marker_replication.value.status
        }
      }

      dynamic "existing_object_replication" {
        for_each = rule.value.existing_object_replication != null ? [rule.value.existing_object_replication] : []
        content {
          status = existing_object_replication.value.status
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count                 = var.object_lock_configuration != null ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  object_lock_enabled   = var.object_lock_configuration.object_lock_enabled

  dynamic "rule" {
    for_each = var.object_lock_configuration.rule != null ? [var.object_lock_configuration.rule] : []
    content {
      default_retention {
        mode  = rule.value.default_retention.mode
        days  = rule.value.default_retention.days
        years = rule.value.default_retention.years
      }
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count  = length(var.intelligent_tiering)
  bucket = aws_s3_bucket.this.id
  name   = var.intelligent_tiering[count.index].name
  status = var.intelligent_tiering[count.index].status

  dynamic "filter" {
    for_each = var.intelligent_tiering[count.index].filter != null ? [var.intelligent_tiering[count.index].filter] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }

  dynamic "tiering" {
    for_each = var.intelligent_tiering[count.index].tiering
    content {
      access_tier = tiering.value.access_tier
      days        = tiering.value.days
    }
  }
}

resource "aws_s3_bucket_inventory" "this" {
  count                        = length(var.inventory_configuration)
  bucket                       = aws_s3_bucket.this.id
  name                         = var.inventory_configuration[count.index].name
  included_object_versions     = var.inventory_configuration[count.index].included_object_versions

  schedule {
    frequency = var.inventory_configuration[count.index].schedule.frequency
  }

  destination {
    bucket {
      format     = var.inventory_configuration[count.index].destination.bucket.format
      bucket_arn = var.inventory_configuration[count.index].destination.bucket.bucket_arn
      prefix     = var.inventory_configuration[count.index].destination.bucket.prefix
      account_id = var.inventory_configuration[count.index].destination.bucket.account_id

      dynamic "encryption" {
        for_each = var.inventory_configuration[count.index].destination.bucket.encryption != null ? [var.inventory_configuration[count.index].destination.bucket.encryption] : []
        content {
          dynamic "sse_kms" {
            for_each = encryption.value.sse_kms != null ? [encryption.value.sse_kms] : []
            content {
              key_id = sse_kms.value.key_id
            }
          }
          dynamic "sse_s3" {
            for_each = encryption.value.sse_s3 != null ? [encryption.value.sse_s3] : []
            content {}
          }
        }
      }
    }
  }

  dynamic "filter" {
    for_each = var.inventory_configuration[count.index].filter != null ? [var.inventory_configuration[count.index].filter] : []
    content {
      prefix = filter.value.prefix
    }
  }

  optional_fields = var.inventory_configuration[count.index].optional_fields
}

resource "aws_s3_bucket_metric" "this" {
  count  = length(var.metric_configuration)
  bucket = aws_s3_bucket.this.id
  name   = var.metric_configuration[count.index].name

  dynamic "filter" {
    for_each = var.metric_configuration[count.index].filter != null ? [var.metric_configuration[count.index].filter] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  payer  = var.request_payer
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.bucket_policy != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_accelerate_configuration" "this" {
  count  = var.acceleration_status != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  status = var.acceleration_status
}