# Lifecycle Policy S3 Bucket Example

This example creates an S3 bucket with comprehensive lifecycle policies for cost optimization.

## Features

- Creates an S3 bucket with versioning enabled
- Configures multiple lifecycle rules
- Demonstrates storage class transitions
- Shows cleanup policies for temporary files

## Lifecycle Rules

### Rule 1: cleanup_old_versions
- Transitions objects to Standard-IA after 30 days
- Transitions objects to Glacier after 90 days
- Transitions objects to Deep Archive after 180 days
- Deletes current versions after 365 days
- Deletes noncurrent versions after 90 days
- Transitions noncurrent versions to Glacier after 30 days
- Aborts incomplete multipart uploads after 7 days

### Rule 2: delete_temp_files
- Applies to objects with "temp/" prefix
- Deletes objects after 1 day

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## What's Created

- S3 bucket with versioning enabled
- Lifecycle policies for automatic cost optimization
- Storage class transitions to reduce costs over time
- Cleanup rules for temporary and old data

This example demonstrates how to implement a comprehensive data lifecycle management strategy to optimize storage costs.