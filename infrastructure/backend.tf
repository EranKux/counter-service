terraform {
  backend "s3" {
    bucket         = "counter-state-bucket"
    key            = "terraform/state"
    region         = "eu-central-1"
    dynamodb_table = "counter-lock-table"
    encrypt        = true
  }
}
