output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = aws_sqs_queue.this.name
}

output "queue_url" {
  description = "Same as queue_id: The URL for the created Amazon SQS queue"
  value       = aws_sqs_queue.this.url
}

output "dead_letter_queue_id" {
  description = "The URL for the created Amazon SQS dead letter queue"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].id : null
}

output "dead_letter_queue_arn" {
  description = "The ARN of the SQS dead letter queue"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].arn : null
}

output "dead_letter_queue_name" {
  description = "The name of the SQS dead letter queue"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].name : null
}

output "dead_letter_queue_url" {
  description = "Same as dead_letter_queue_id: The URL for the created Amazon SQS dead letter queue"
  value       = var.create_dlq ? aws_sqs_queue.dead_letter_queue[0].url : null
}