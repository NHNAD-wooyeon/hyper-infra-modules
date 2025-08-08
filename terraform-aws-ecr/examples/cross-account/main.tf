module "shared_ecr" {
  source = "../../"
  
  repository_name = "shared-microservice"
  
  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountPull"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111111111111:root",  # Development account
            "arn:aws:iam::222222222222:root",  # Staging account
            "arn:aws:iam::333333333333:root"   # Production account
          ]
        }
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      },
      {
        Sid    = "AllowCrossAccountDescribe"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::111111111111:root",
            "arn:aws:iam::222222222222:root",
            "arn:aws:iam::333333333333:root"
          ]
        }
        Action = [
          "ecr:DescribeRepositories",
          "ecr:DescribeImages"
        ]
      }
    ]
  })
  
  tags = {
    Environment = "shared"
    Project     = "microservices"
    Shared      = "true"
  }
}