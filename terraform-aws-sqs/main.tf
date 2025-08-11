resource "aws_sqs_queue" "this" {
  name                              = var.name
  delay_seconds                     = var.delay_seconds
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  deduplication_scope               = var.deduplication_scope
  fifo_throughput_limit             = var.fifo_throughput_limit
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled

  dynamic "redrive_policy" {
    for_each = var.redrive_policy != null ? [var.redrive_policy] : []
    content {
      dead_letter_target_arn = redrive_policy.value.dead_letter_target_arn
      max_receive_count      = redrive_policy.value.max_receive_count
    }
  }

  dynamic "redrive_allow_policy" {
    for_each = var.redrive_allow_policy != null ? [var.redrive_allow_policy] : []
    content {
      redrivePermission = redrive_allow_policy.value.redrivePermission
      sourceQueueArns   = redrive_allow_policy.value.sourceQueueArns
    }
  }

  tags = var.tags
}

resource "aws_sqs_queue_policy" "this" {
  count     = var.policy != null ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  policy    = var.policy
}

resource "aws_sqs_queue" "dead_letter_queue" {
  count                         = var.create_dlq ? 1 : 0
  name                          = var.dlq_name != null ? var.dlq_name : "${var.name}-dlq"
  delay_seconds                 = var.dlq_delay_seconds
  max_message_size              = var.dlq_max_message_size
  message_retention_seconds     = var.dlq_message_retention_seconds
  receive_wait_time_seconds     = var.dlq_receive_wait_time_seconds
  visibility_timeout_seconds    = var.dlq_visibility_timeout_seconds
  fifo_queue                    = var.fifo_queue
  content_based_deduplication   = var.content_based_deduplication
  deduplication_scope           = var.deduplication_scope
  fifo_throughput_limit         = var.fifo_throughput_limit
  kms_master_key_id             = var.dlq_kms_master_key_id
  kms_data_key_reuse_period_seconds = var.dlq_kms_data_key_reuse_period_seconds
  sqs_managed_sse_enabled       = var.dlq_sqs_managed_sse_enabled

  tags = var.dlq_tags != null ? var.dlq_tags : var.tags
}