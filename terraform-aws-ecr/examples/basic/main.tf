module "basic_ecr" {
  source = "../../"
  
  repository_name = "my-basic-app"
  
  tags = {
    Environment = "development"
    Project     = "example"
  }
}