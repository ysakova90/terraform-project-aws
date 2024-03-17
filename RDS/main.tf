data "aws_caller_identity" "current" {}


locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "terraform_remote_state" "backend" {
  backend = "s3"
   config  = {
    bucket = "team1-aws-storage"
    key = "path/to/my/tfstate"
    region = "us-east-1"
  }
}



resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = [ 
    data.terraform_remote_state.backend.outputs.private_subnet1,
    data.terraform_remote_state.backend.outputs.private_subnet2,
    data.terraform_remote_state.backend.outputs.private_subnet3
  ]

}