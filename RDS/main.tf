##Create subnet group for RDS
resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = [
    data.terraform_remote_state.backend.outputs.private_subnet1,
    data.terraform_remote_state.backend.outputs.private_subnet2,
    data.terraform_remote_state.backend.outputs.private_subnet3,
  ]

  tags = var.tags
}