# VPC Lambda example - Lambda function running in private subnets
module "vpc_lambda" {
  source = "../../"
  
  function_name = "vpc-database-processor"
  filename      = "processor.zip"
  handler       = "processor.main"
  runtime       = "python3.9"
  timeout       = 120
  memory_size   = 512
  
  vpc_config = {
    subnet_ids = [
      "subnet-private-1a",  # Replace with your private subnet IDs
      "subnet-private-1b"
    ]
    security_group_ids = [
      "sg-lambda-database"  # Replace with your security group ID
    ]
  }
  
  environment_variables = {
    DB_HOST     = "rds.internal.company.com"
    DB_PORT     = "5432"
    DB_NAME     = "production"
    REDIS_HOST  = "redis.internal.company.com"
  }
  
  # Additional permissions needed for VPC Lambda
  # The module automatically attaches AWSLambdaVPCAccessExecutionRole
  
  log_retention_in_days = 30
  
  tags = {
    Environment = "production"
    Project     = "data-processing"
    Network     = "private"
    Database    = "postgresql"
  }
}