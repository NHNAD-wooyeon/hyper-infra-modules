module "scheduled_lambda" {
  source = "../../"
  
  function_name = "daily-report-generator"
  filename      = "report.zip"
  handler       = "report.generate"
  runtime       = "python3.9"
  timeout       = 300
  memory_size   = 256
  
  # Run every day at 6 AM UTC
  cloudwatch_schedule_expression = "cron(0 6 * * ? *)"
  
  environment_variables = {
    REPORT_BUCKET = "my-reports-bucket"
    TIMEZONE      = "UTC"
    RECIPIENTS    = "team@company.com"
  }
  
  dead_letter_config = {
    target_arn = "arn:aws:sqs:us-west-2:123456789012:report-dlq"
  }
  
  log_retention_in_days = 7
  
  tags = {
    Environment = "production"
    Project     = "reporting"
    Schedule    = "daily"
    Owner       = "data-team"
  }
}