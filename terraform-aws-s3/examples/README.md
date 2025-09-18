# S3 Module Examples

This directory contains examples of how to use the S3 Terraform module.

## Examples

### [basic/](./basic/)
Simple S3 bucket with minimal configuration - demonstrates the most basic usage of the module.

### [encrypted/](./encrypted/)
S3 bucket with KMS encryption and versioning enabled - shows how to configure server-side encryption.

### [website/](./website/)
Static website hosting configuration - demonstrates how to set up an S3 bucket for static website hosting.

### [lifecycle/](./lifecycle/)
Advanced lifecycle policies for cost optimization - shows how to configure object lifecycle management.

### [replication/](./replication/)
Cross-region replication setup - demonstrates how to configure cross-region replication.

### [compliance/](./compliance/)
Object lock for regulatory compliance - shows how to configure object lock for compliance requirements.

## Usage

Each example directory contains:
- `main.tf` - The main Terraform configuration
- `variables.tf` - Input variables (if any)
- `outputs.tf` - Output values
- `README.md` - Specific example documentation

To run any example:

1. Navigate to the example directory
2. Initialize Terraform: `terraform init`
3. Plan the deployment: `terraform plan`
4. Apply the configuration: `terraform apply`

Remember to customize the variables according to your specific requirements.