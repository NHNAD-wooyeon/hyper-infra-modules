module "basic_sqs" {
  source = "../../"
  
  name = "my-basic-queue"
  
  tags = {
    Environment = "development"
    Project     = "example"
  }
}