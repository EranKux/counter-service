terraform {
  backend "s3" {
    bucket         = "terraform-state-eu-west-1-eran"
    key            = "terraform/state"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
