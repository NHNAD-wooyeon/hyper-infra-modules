# AWS Lambda Terraform Module

This module creates and manages an AWS Lambda function with comprehensive configuration options including IAM roles, CloudWatch logging, VPC configuration, and scheduled execution.

## Features

- ✅ Lambda function creation with multiple deployment options (ZIP, S3, Container Image)
- ✅ Automatic IAM role creation or use existing role
- ✅ CloudWatch Log Group creation with configurable retention
- ✅ Environment variables support
- ✅ VPC configuration for private subnet execution
- ✅ Dead letter queue configuration
- ✅ X-Ray tracing support
- ✅ CloudWatch Events scheduling
- ✅ EFS file system mounting
- ✅ Container image configuration
- ✅ Comprehensive tagging

## Usage

### Basic Usage (ZIP file)

```hcl
module "lambda" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  function_name = "my-lambda-function"
  filename      = "function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
}
```

### S3 Deployment

```hcl
module "lambda" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  function_name = "my-lambda-function"
  s3_bucket     = "my-deployment-bucket"
  s3_key        = "lambda/function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  
  environment_variables = {
    ENV = "production"
    DB_HOST = "db.example.com"
  }
}
```

### Container Image Deployment

```hcl
module "lambda" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  function_name = "my-container-lambda"
  package_type  = "Image"
  image_uri     = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-lambda:latest"
  
  image_config = {
    command = ["app.handler"]
  }
}
```

### Advanced Configuration

```hcl
module "lambda" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  function_name    = "advanced-lambda"
  filename         = "function.zip"
  handler          = "index.handler"
  runtime          = "python3.9"
  timeout          = 30
  memory_size      = 512
  description      = "Advanced Lambda function with full configuration"
  
  environment_variables = {
    ENV        = "production"
    LOG_LEVEL  = "INFO"
    API_KEY    = "encrypted-key"
  }
  
  vpc_config = {
    subnet_ids         = ["subnet-12345", "subnet-67890"]
    security_group_ids = ["sg-12345"]
  }
  
  tracing_config = {
    mode = "Active"
  }
  
  dead_letter_config = {
    target_arn = "arn:aws:sqs:us-west-2:123456789012:dlq"
  }
  
  log_retention_in_days = 30
  
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "platform-team"
  }
}
```

### Scheduled Lambda

```hcl
module "scheduled_lambda" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  function_name = "daily-cleanup"
  filename      = "cleanup.zip"
  handler       = "cleanup.handler"
  runtime       = "python3.9"
  
  cloudwatch_schedule_expression = "cron(0 2 * * ? *)"  # Run daily at 2 AM UTC
  
  tags = {
    Schedule = "daily"
  }
}
```

### Using Existing IAM Role

```hcl
module "lambda" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  function_name = "my-lambda"
  filename      = "function.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  role_arn      = "arn:aws:iam::123456789012:role/my-existing-lambda-role"
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
| function_name | The name of the Lambda function | `string` | n/a | yes |
| role_arn | IAM role ARN attached to the Lambda Function. If not provided, a default role will be created | `string` | `null` | no |
| handler | The function entrypoint in your code | `string` | `"index.handler"` | no |
| runtime | The runtime environment for the Lambda function | `string` | `"python3.9"` | no |
| timeout | The amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| memory_size | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| filename | The path to the function's deployment package within the local filesystem | `string` | `null` | no |
| s3_bucket | The S3 bucket location containing the function's deployment package | `string` | `null` | no |
| s3_key | The S3 key of an object containing the function's deployment package | `string` | `null` | no |
| image_uri | The URI of the container image in the Amazon ECR registry | `string` | `null` | no |
| package_type | The Lambda deployment package type | `string` | `"Zip"` | no |
| environment_variables | A map that defines environment variables for the Lambda function | `map(string)` | `null` | no |
| vpc_config | VPC configuration for the Lambda function | `object` | `null` | no |
| cloudwatch_schedule_expression | A CloudWatch schedule expression for triggering the Lambda function | `string` | `null` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_arn | The ARN of the Lambda Function |
| lambda_function_name | The name of the Lambda Function |
| lambda_function_invoke_arn | The Invoke ARN of the Lambda Function |
| lambda_role_arn | The ARN of the IAM role created for the Lambda Function |
| lambda_cloudwatch_log_group_name | The name of the CloudWatch Log Group |

## Examples

See the `examples/` directory for complete working examples.

## License

This module is licensed under the MIT License.