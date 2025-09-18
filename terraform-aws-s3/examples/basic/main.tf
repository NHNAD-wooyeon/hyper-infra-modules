module "basic_s3" {
  source = "../../"

  bucket = "my-basic-bucket-${random_string.suffix.result}"

  tags = {
    Environment = "development"
    Example     = "basic"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}