module "container_lambda" {
  source = "../../"
  
  function_name = "container-lambda-app"
  package_type  = "Image"
  image_uri     = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-lambda-app:latest"
  timeout       = 60
  memory_size   = 1024
  
  image_config = {
    command = ["app.handler"]
    entry_point = ["/lambda-entrypoint.sh"]
  }
  
  environment_variables = {
    STAGE = "production"
    DATABASE_URL = "postgresql://user:pass@host:5432/db"
  }
  
  tracing_config = {
    mode = "Active"
  }
  
  tags = {
    Environment = "production"
    Project     = "container-app"
    Runtime     = "container"
  }
}