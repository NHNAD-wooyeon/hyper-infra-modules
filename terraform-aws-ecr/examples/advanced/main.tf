module "production_ecr" {
  source = "../../"
  
  repository_name      = "production-web-app"
  image_tag_mutability = "IMMUTABLE"
  
  image_scanning_configuration = {
    scan_on_push = true
  }
  
  encryption_configuration = {
    encryption_type = "AES256"
  }
  
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 production images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["prod"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  tags = {
    Environment = "production"
    Project     = "web-app"
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}