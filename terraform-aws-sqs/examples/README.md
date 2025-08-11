# SQS Module Examples

This directory contains various examples demonstrating different use cases for the terraform-aws-sqs module.

## Examples

- **basic** - Simple SQS queue with minimal configuration
- **advanced** - Queue with encryption, custom retention, and visibility timeout
- **fifo** - FIFO queue with content-based deduplication
- **dlq** - Standard queue with dead letter queue configuration

## Usage

Navigate to any example directory and run:

```bash
terraform init
terraform plan
terraform apply
```

Make sure to update the source path in each example to point to your module location.