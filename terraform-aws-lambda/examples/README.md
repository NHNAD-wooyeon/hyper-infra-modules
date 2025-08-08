# Lambda Module Examples

This directory contains various examples showing how to use the Lambda Terraform module.

## Examples

### Basic Example (`basic/`)
- Simple Lambda function with ZIP deployment
- Environment variables configuration
- Basic logging setup
- Good for getting started

### Container Example (`container/`)
- Lambda function using container images
- ECR image deployment
- Container-specific configuration
- X-Ray tracing enabled

### Scheduled Example (`scheduled/`)
- Lambda function triggered by CloudWatch Events
- Cron expression scheduling
- Dead letter queue configuration
- Log retention settings

### VPC Example (`vpc/`)
- Lambda function running in VPC private subnets
- Database and Redis connectivity
- Security group configuration
- Enhanced logging for production

## Running Examples

To run any example:

1. Navigate to the example directory:
   ```bash
   cd examples/basic  # or container, scheduled, vpc
   ```

2. Update the configuration:
   - Replace placeholder values (subnet IDs, security groups, etc.)
   - Ensure your deployment package (ZIP file or container image) exists

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Prerequisites

### For ZIP Deployments
- Create your deployment package (ZIP file)
- Ensure the handler path matches your code structure

### For Container Deployments  
- Build and push your container image to ECR
- Update the `image_uri` with your actual ECR repository URI

### For VPC Examples
- Have VPC, subnets, and security groups already created
- Update the example with your actual resource IDs

## Testing Your Lambda

After deployment, you can test your Lambda function:

```bash
# Invoke function directly
aws lambda invoke \
  --function-name your-function-name \
  --payload '{"test": "data"}' \
  response.json

# View logs
aws logs describe-log-groups \
  --log-group-name-prefix "/aws/lambda/your-function-name"
```

## Clean Up

Don't forget to clean up resources when done:
```bash
terraform destroy
```