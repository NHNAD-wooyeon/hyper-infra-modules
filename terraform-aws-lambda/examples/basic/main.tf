module "basic_lambda" {
  source = "../../"
  
  function_name = "basic-hello-world"
  filename      = "hello.zip"
  handler       = "index.handler"
  runtime       = "python3.9"
  
  environment_variables = {
    ENVIRONMENT = "development"
    LOG_LEVEL   = "DEBUG"
  }
  
  tags = {
    Environment = "development"
    Project     = "example"
  }
}