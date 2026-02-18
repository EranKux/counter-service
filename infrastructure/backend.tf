terraform {
  backend "s3" {
    bucket         = "terraform-state-eu-west-1-eran"
    key            = "terraform/state"
    region         = "eu-west-1"
    use_lockfile   = true
    encrypt        = true
  }
}
