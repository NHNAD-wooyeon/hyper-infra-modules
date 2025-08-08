# Hyper Infrastructure Modules

A collection of reusable Terraform modules for AWS infrastructure components.

## Available Modules

| Module | Description | Latest Version |
|--------|-------------|----------------|
| [terraform-aws-ecr](./terraform-aws-ecr/) | AWS Elastic Container Registry | v1.0.0 |
| [terraform-aws-lambda](./terraform-aws-lambda/) | AWS Lambda Functions | v1.0.0 |

## Usage

```hcl
module "example" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  # Module-specific variables
  repository_name = "my-app"
}
```

## Version Management Standards

This repository follows [Semantic Versioning](https://semver.org/) (SemVer) for all module releases.

### Version Format: `vMAJOR.MINOR.PATCH`

#### MAJOR Version (`v2.0.0`)
**When to increment:** Breaking changes that require user action

**Examples:**
- Removing or renaming input variables
- Changing required provider versions significantly
- Removing resources or outputs
- Changing default behaviors that could break existing infrastructure

**Example Scenarios:**
```hcl
# v1.x.x - Old variable name
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# v2.0.0 - Breaking change: renamed variable
variable "repository_name" {  # ← Breaking change
  description = "Name of the ECR repository" 
  type        = string
}
```

**Commit Message:**
```
feat!: rename bucket_name variable to repository_name

BREAKING CHANGE: The variable `bucket_name` has been renamed to `repository_name` 
to better reflect the ECR resource. Update your module calls accordingly.

Before: bucket_name = "my-app"
After:  repository_name = "my-app"
```

#### MINOR Version (`v1.1.0`)
**When to increment:** New features that are backward compatible

**Examples:**
- Adding new optional input variables
- Adding new output values
- Adding new optional resources
- New functionality that doesn't break existing usage

**Example Scenarios:**
```hcl
# v1.0.0 - Original module

# v1.1.0 - Added new optional feature
variable "enable_vulnerability_scanning" {  # ← New optional variable
  description = "Enable vulnerability scanning"
  type        = bool
  default     = false  # ← Safe default
}
```

**Commit Message:**
```
feat: add vulnerability scanning support

- Add enable_vulnerability_scanning variable
- Add vulnerability_scan_results output
- Add aws_ecr_registry_scanning_configuration resource
- Scanning is disabled by default for backward compatibility
```

#### PATCH Version (`v1.0.1`)
**When to increment:** Bug fixes and non-functional improvements

**Examples:**
- Fixing bugs in existing functionality
- Documentation updates
- Code refactoring without behavior changes
- Dependency updates (minor)
- Improving variable validation

**Example Scenarios:**
```hcl
# v1.0.0 - Bug: missing validation
variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 128
}

# v1.0.1 - Bug fix: add proper validation
variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 128
  validation {  # ← Bug fix: added missing validation
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }
}
```

**Commit Message:**
```
fix: add memory_size validation for Lambda module

- Add validation to ensure memory_size is within AWS limits (128-10240 MB)
- Prevents runtime errors when applying invalid memory configurations
- No breaking changes to existing functionality
```

## Commit Message Standards

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description | Version Impact |
|------|-------------|----------------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `feat!` / `fix!` | Breaking change | MAJOR |
| `docs` | Documentation only | PATCH |
| `style` | Code style changes | PATCH |
| `refactor` | Code refactoring | PATCH |
| `test` | Adding tests | PATCH |
| `chore` | Maintenance tasks | PATCH |

### Examples

#### New Module
```
feat: add terraform-aws-lambda module

- Create Lambda function resource with IAM role
- Support ZIP, S3, and container image deployment
- Add CloudWatch logging and VPC configuration
- Include comprehensive examples and documentation
```

#### Bug Fix
```
fix: correct IAM policy for Lambda VPC execution

- Add missing VPC execution policy attachment
- Fixes Lambda timeout issues in VPC environments
- Resolves issue #123
```

#### Breaking Change
```
feat!: upgrade to AWS provider v5.x

BREAKING CHANGE: Minimum AWS provider version is now 5.0.
This requires Terraform >= 1.0 and may require state migration.

- Update provider constraints in versions.tf
- Remove deprecated resource attributes
- Update examples to use new provider syntax
```

#### Documentation Update
```
docs: update ECR module usage examples

- Add container image scanning example
- Fix typo in cross-account policy
- Update README with new output variables
```

## Release Workflow

### 1. Development
```bash
# Create feature branch
git checkout -b feature/add-lambda-layers

# Make your changes
# Write tests and documentation

# Commit with conventional format
git commit -m "feat: add Lambda layers support"
```

### 2. Testing
```bash
# Test your changes
terraform init
terraform plan
terraform apply
terraform destroy
```

### 3. Release Process
```bash
# Merge to main
git checkout main
git pull origin main

# Create and push version tag
git tag v1.1.0
git push origin v1.1.0

# Or for major releases with breaking changes
git tag v2.0.0
git push origin v2.0.0
```

### 4. Version Tag Examples

```bash
# First release
git tag v1.0.0

# Bug fix
git tag v1.0.1

# New feature (backward compatible)
git tag v1.1.0

# Breaking change
git tag v2.0.0

# Multiple fixes
git tag v1.0.2
git tag v1.0.3
```

## Best Practices

### Module Development
- ✅ Always provide safe defaults for new variables
- ✅ Use validation blocks for input parameters
- ✅ Include comprehensive documentation
- ✅ Provide working examples
- ✅ Test with multiple Terraform/provider versions

### Version Management
- ✅ Never reuse or delete published version tags
- ✅ Follow semantic versioning strictly
- ✅ Use conventional commit messages
- ✅ Document breaking changes clearly
- ✅ Test thoroughly before tagging releases

### User Communication
- ✅ Maintain CHANGELOG.md for major changes
- ✅ Use GitHub releases for important updates
- ✅ Provide migration guides for breaking changes
- ✅ Respond to issues and feature requests promptly

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the standards above
4. Submit a pull request with clear description
5. Ensure all tests pass and documentation is updated

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.