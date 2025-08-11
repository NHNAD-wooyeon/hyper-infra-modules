module "fifo_sqs" {
  source = "../../"
  
  name                        = "my-fifo-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  
  tags = {
    Environment = "production"
    Type        = "fifo"
    Application = "order-processing"
  }
}