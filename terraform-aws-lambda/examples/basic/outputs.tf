output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.basic_lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.basic_lambda.lambda_function_name
}

output "lambda_function_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = module.basic_lambda.lambda_function_invoke_arn
}