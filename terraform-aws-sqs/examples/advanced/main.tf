module "advanced_sqs" {
  source = "../../"
  
  name                       = "advanced-production-queue"
  delay_seconds              = 30
  max_message_size           = 262144
  message_retention_seconds  = 864000
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 120
  sqs_managed_sse_enabled    = true
  
  tags = {
    Environment   = "production"
    Application   = "payment-processing"
    CriticalLevel = "high"
  }
}