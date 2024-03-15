data "aws_caller_identity" "current" {}


locals {
  account_id = data.aws_caller_identity.current.account_id
}


data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = "tfstate-${local.account_id}"
    key    = "tfstate-team1/dev/VPC"
    region = "us-east-1"
  }
}
