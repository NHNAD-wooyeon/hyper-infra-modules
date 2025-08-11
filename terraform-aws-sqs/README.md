# AWS SQS Terraform Module

This module creates and manages an AWS Simple Queue Service (SQS) queue with configurable options for FIFO queues, dead letter queues, encryption, message retention, and comprehensive queue policies.

## Features

- ✅ Standard and FIFO SQS queue creation
- ✅ Dead Letter Queue (DLQ) support
- ✅ Server-side encryption (SSE) with KMS or SQS-managed keys
- ✅ Message retention and visibility timeout configuration
- ✅ Redrive policies for dead letter queues
- ✅ Queue policies for cross-account access
- ✅ Content-based deduplication for FIFO queues
- ✅ Comprehensive tagging

## Usage

### Basic Usage

```hcl
module "sqs" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-sqs?ref=v1.0.0"
  
  name = "my-queue"
}
```

### Standard Queue with Dead Letter Queue

```hcl
module "sqs" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-sqs?ref=v1.0.0"
  
  name                       = "my-production-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 1209600
  
  create_dlq = true
  dlq_name   = "my-production-queue-dlq"
  
  redrive_policy = {
    dead_letter_target_arn = module.sqs.dead_letter_queue_arn
    max_receive_count      = 3
  }
  
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "backend-team"
  }
}
```

### FIFO Queue with Encryption

```hcl
module "fifo_sqs" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-sqs?ref=v1.0.0"
  
  name                        = "my-fifo-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  
  kms_master_key_id                 = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
  kms_data_key_reuse_period_seconds = 300
  
  create_dlq = true
  
  tags = {
    Environment = "production"
    Type        = "fifo"
  }
}
```

### Queue with Custom Policy

```hcl
module "shared_sqs" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-sqs?ref=v1.0.0"
  
  name = "shared-queue"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountSendMessage"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::123456789012:root",
            "arn:aws:iam::123456789013:root"
          ]
        }
        Action   = "sqs:SendMessage"
        Resource = "*"
      },
      {
        Sid    = "AllowCrossAccountReceiveMessage"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:user/service-user"
        }
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ]
        Resource = "*"
      }
    ]
  })
  
  tags = {
    Shared = "true"
  }
}
```

### Advanced Configuration with SQS-Managed Encryption

```hcl
module "advanced_sqs" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-sqs?ref=v1.0.0"
  
  name                       = "advanced-queue"
  delay_seconds              = 30
  max_message_size           = 262144
  message_retention_seconds  = 864000
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 120
  sqs_managed_sse_enabled    = true
  
  create_dlq                        = true
  dlq_message_retention_seconds     = 1209600
  dlq_sqs_managed_sse_enabled       = true
  
  redrive_policy = {
    dead_letter_target_arn = module.advanced_sqs.dead_letter_queue_arn
    max_receive_count      = 5
  }
  
  tags = {
    Environment   = "production"
    Application   = "payment-processing"
    CriticalLevel = "high"
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
| name | The name of the SQS queue | `string` | n/a | yes |
| delay_seconds | The time in seconds that the delivery of all messages in the queue will be delayed | `number` | `0` | no |
| max_message_size | The limit of how many bytes a message can contain before Amazon SQS rejects it | `number` | `262144` | no |
| message_retention_seconds | The number of seconds Amazon SQS retains a message | `number` | `1209600` | no |
| receive_wait_time_seconds | The time for which a ReceiveMessage call will wait for a message to arrive | `number` | `0` | no |
| visibility_timeout_seconds | The visibility timeout for the queue | `number` | `30` | no |
| fifo_queue | Boolean designating a FIFO queue | `bool` | `false` | no |
| content_based_deduplication | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| deduplication_scope | Specifies whether message deduplication occurs at the message group or queue level | `string` | `null` | no |
| fifo_throughput_limit | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group | `string` | `null` | no |
| kms_master_key_id | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK | `string` | `null` | no |
| kms_data_key_reuse_period_seconds | The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages | `number` | `300` | no |
| sqs_managed_sse_enabled | Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys | `bool` | `false` | no |
| redrive_policy | The JSON policy to set up the Dead Letter Queue | `object({ dead_letter_target_arn = string, max_receive_count = number })` | `null` | no |
| redrive_allow_policy | The JSON policy to set up the Dead Letter Queue redrive permission | `object({ redrivePermission = string, sourceQueueArns = list(string) })` | `null` | no |
| policy | The JSON policy for the SQS queue | `string` | `null` | no |
| tags | A map of tags to assign to the queue | `map(string)` | `{}` | no |
| create_dlq | Create a dead letter queue | `bool` | `false` | no |
| dlq_name | The name of the dead letter queue. If not provided, defaults to '{name}-dlq' | `string` | `null` | no |
| dlq_delay_seconds | The time in seconds that the delivery of all messages in the dead letter queue will be delayed | `number` | `0` | no |
| dlq_max_message_size | The limit of how many bytes a message can contain in the dead letter queue | `number` | `262144` | no |
| dlq_message_retention_seconds | The number of seconds Amazon SQS retains a message in the dead letter queue | `number` | `1209600` | no |
| dlq_receive_wait_time_seconds | The time for which a ReceiveMessage call will wait for a message in the dead letter queue | `number` | `0` | no |
| dlq_visibility_timeout_seconds | The visibility timeout for the dead letter queue | `number` | `30` | no |
| dlq_kms_master_key_id | The KMS key ID for the dead letter queue | `string` | `null` | no |
| dlq_kms_data_key_reuse_period_seconds | The KMS data key reuse period for the dead letter queue | `number` | `300` | no |
| dlq_sqs_managed_sse_enabled | Boolean to enable SSE for the dead letter queue | `bool` | `false` | no |
| dlq_tags | A map of tags to assign to the dead letter queue | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| queue_id | The URL for the created Amazon SQS queue |
| queue_arn | The ARN of the SQS queue |
| queue_name | The name of the SQS queue |
| queue_url | Same as queue_id: The URL for the created Amazon SQS queue |
| dead_letter_queue_id | The URL for the created Amazon SQS dead letter queue |
| dead_letter_queue_arn | The ARN of the SQS dead letter queue |
| dead_letter_queue_name | The name of the SQS dead letter queue |
| dead_letter_queue_url | Same as dead_letter_queue_id: The URL for the created Amazon SQS dead letter queue |

## Examples

See the `examples/` directory for complete working examples:

- **basic** - Simple SQS queue with minimal configuration
- **advanced** - Queue with encryption, custom retention, and visibility timeout
- **fifo** - FIFO queue with content-based deduplication
- **dlq** - Standard queue with dead letter queue configuration

## License

This module is licensed under the MIT License.