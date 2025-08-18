# Most basic SQS queue - only required parameter is 'name'
module "minimal_sqs" {
  source = "../../"
  
  name = "my-basic-queue"
}

# Basic SQS queue with common optional parameters
module "basic_sqs" {
  source = "../../"
  
  name                       = "my-queue"
  visibility_timeout_seconds = 300
  
  tags = {
    Environment = "development"
    Project     = "example"
  }
}