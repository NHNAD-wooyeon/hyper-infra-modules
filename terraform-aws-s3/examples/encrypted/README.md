# Encrypted S3 Bucket Example

This example creates an S3 bucket with server-side encryption and versioning enabled.

## Features

- Creates an S3 bucket with AES256 encryption
- Enables versioning for object history
- Demonstrates security best practices

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## What's Created

- S3 bucket with server-side encryption (AES256)
- Versioning enabled
- Default public access block settings
- Tags for identification and compliance tracking

This example shows how to create a secure S3 bucket suitable for production environments.