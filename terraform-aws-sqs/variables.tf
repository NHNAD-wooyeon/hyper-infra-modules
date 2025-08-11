variable "name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
  default     = 0
  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "Delay seconds must be between 0 and 900."
  }
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  type        = number
  default     = 262144
  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 262144
    error_message = "Max message size must be between 1024 and 262144 bytes."
  }
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
  default     = 1209600
  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "Message retention seconds must be between 60 and 1209600."
  }
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive"
  type        = number
  default     = 0
  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "Receive wait time seconds must be between 0 and 20."
  }
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  type        = number
  default     = 30
  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "Visibility timeout seconds must be between 0 and 43200."
  }
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level"
  type        = string
  default     = null
  validation {
    condition     = var.deduplication_scope == null || contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "Deduplication scope must be either 'messageGroup' or 'queue'."
  }
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group"
  type        = string
  default     = null
  validation {
    condition     = var.fifo_throughput_limit == null || contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "FIFO throughput limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages"
  type        = number
  default     = 300
  validation {
    condition     = var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400
    error_message = "KMS data key reuse period seconds must be between 60 and 86400."
  }
}

variable "sqs_managed_sse_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys"
  type        = bool
  default     = false
}

variable "redrive_policy" {
  description = "The JSON policy to set up the Dead Letter Queue"
  type = object({
    dead_letter_target_arn = string
    max_receive_count      = number
  })
  default = null
}

variable "redrive_allow_policy" {
  description = "The JSON policy to set up the Dead Letter Queue redrive permission"
  type = object({
    redrivePermission = string
    sourceQueueArns   = list(string)
  })
  default = null
}

variable "policy" {
  description = "The JSON policy for the SQS queue"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the queue"
  type        = map(string)
  default     = {}
}

# Dead Letter Queue Variables
variable "create_dlq" {
  description = "Create a dead letter queue"
  type        = bool
  default     = false
}

variable "dlq_name" {
  description = "The name of the dead letter queue. If not provided, defaults to '{name}-dlq'"
  type        = string
  default     = null
}

variable "dlq_delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the dead letter queue will be delayed"
  type        = number
  default     = 0
}

variable "dlq_max_message_size" {
  description = "The limit of how many bytes a message can contain in the dead letter queue"
  type        = number
  default     = 262144
}

variable "dlq_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message in the dead letter queue"
  type        = number
  default     = 1209600
}

variable "dlq_receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message in the dead letter queue"
  type        = number
  default     = 0
}

variable "dlq_visibility_timeout_seconds" {
  description = "The visibility timeout for the dead letter queue"
  type        = number
  default     = 30
}

variable "dlq_kms_master_key_id" {
  description = "The KMS key ID for the dead letter queue"
  type        = string
  default     = null
}

variable "dlq_kms_data_key_reuse_period_seconds" {
  description = "The KMS data key reuse period for the dead letter queue"
  type        = number
  default     = 300
}

variable "dlq_sqs_managed_sse_enabled" {
  description = "Boolean to enable SSE for the dead letter queue"
  type        = bool
  default     = false
}

variable "dlq_tags" {
  description = "A map of tags to assign to the dead letter queue"
  type        = map(string)
  default     = null
}