# ECR Module Examples

This directory contains various examples showing how to use the ECR Terraform module.

## Examples

### Basic Example (`basic/`)
- Simple ECR repository with minimal configuration
- Good for development environments
- Uses default settings with basic tagging

### Advanced Example (`advanced/`)
- Production-ready configuration
- Immutable tags for security
- Image scanning enabled
- Lifecycle policy to manage repository size
- Comprehensive tagging strategy

### Cross-Account Example (`cross-account/`)
- Repository shared across multiple AWS accounts
- Repository policy allowing cross-account access
- Useful for multi-account architectures

## Running Examples

To run any example:

1. Navigate to the example directory:
   ```bash
   cd examples/basic  # or advanced, cross-account
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Customization

Each example can be customized by:
- Modifying the variables in `main.tf`
- Adding your own `terraform.tfvars` file
- Extending with additional AWS resources as needed

## Clean Up

Don't forget to clean up resources when done:
```bash
terraform destroy
```