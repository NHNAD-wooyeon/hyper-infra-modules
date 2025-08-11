module "sqs_with_dlq" {
  source = "../../"
  
  name                       = "main-processing-queue"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 1209600
  
  create_dlq = true
  dlq_name   = "main-processing-queue-dlq"
  
  redrive_policy = {
    dead_letter_target_arn = module.sqs_with_dlq.dead_letter_queue_arn
    max_receive_count      = 3
  }
  
  tags = {
    Environment = "production"
    Project     = "data-processing"
    Owner       = "backend-team"
  }
}