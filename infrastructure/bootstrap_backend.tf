resource "aws_s3_bucket" "tf_state" {
  bucket = "counter-state-bucket"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "counter-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "Terraform Lock Table"
    Environment = var.environment
  }
}
