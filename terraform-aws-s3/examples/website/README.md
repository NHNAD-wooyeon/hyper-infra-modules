# Static Website S3 Bucket Example

This example creates an S3 bucket configured for static website hosting.

## Features

- Creates an S3 bucket for static website hosting
- Configures public read access
- Sets up CORS for cross-origin requests
- Defines index and error documents

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## What's Created

- S3 bucket configured for static website hosting
- Public read ACL
- CORS configuration for web browsers
- Website endpoints for serving content
- Public access block disabled (required for public websites)

## After Deployment

1. Upload your website files (index.html, error.html, etc.) to the bucket
2. Access your website using the bucket website endpoint
3. Optionally, configure a custom domain with Route 53

**Warning**: This configuration makes the bucket publicly accessible. Only use for static websites that should be publicly available.