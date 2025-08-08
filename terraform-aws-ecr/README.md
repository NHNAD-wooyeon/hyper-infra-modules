# AWS ECR Terraform Module

This module creates and manages an AWS Elastic Container Registry (ECR) repository with configurable options for image scanning, encryption, lifecycle policies, and repository policies.

## Features

- ✅ ECR repository creation
- ✅ Configurable image tag mutability
- ✅ Image scanning configuration
- ✅ Encryption configuration (KMS or AES256)
- ✅ Lifecycle policy support
- ✅ Repository policy support
- ✅ Comprehensive tagging

## Usage

### Basic Usage

```hcl
module "ecr" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  repository_name = "my-app"
}
```

### Advanced Usage

```hcl
module "ecr" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  repository_name      = "my-production-app"
  image_tag_mutability = "IMMUTABLE"
  
  image_scanning_configuration = {
    scan_on_push = true
  }
  
  encryption_configuration = {
    encryption_type = "KMS"
    kms_key        = "arn:aws:kms:us-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
  
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "devops-team"
  }
}
```

### With Repository Policy

```hcl
module "ecr" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  repository_name = "shared-app"
  
  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountPull"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::123456789012:root",
            "arn:aws:iam::123456789013:root"
          ]
        }
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })
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
| repository_name | The name of the ECR repository | `string` | n/a | yes |
| image_tag_mutability | The tag mutability setting for the repository | `string` | `"MUTABLE"` | no |
| image_scanning_configuration | Configuration block for image scanning | `object({ scan_on_push = bool })` | `{ scan_on_push = true }` | no |
| encryption_configuration | Configuration block for encryption | `object({ encryption_type = string, kms_key = optional(string) })` | `null` | no |
| lifecycle_policy | The lifecycle policy document for the repository | `string` | `null` | no |
| repository_policy | The repository policy document for the repository | `string` | `null` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| repository_arn | Full ARN of the repository |
| repository_name | The name of the repository |
| repository_url | The URL of the repository |
| registry_id | The registry ID where the repository was created |

## Examples

See the `examples/` directory for complete working examples.

## License

This module is licensed under the MIT License.