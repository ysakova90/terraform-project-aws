data "terraform_remote_state" "backend" {
  backend = "s3"
   config  = {
    bucket = "team1-aws-storage"
    key = "vpc-statefile"
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

resource "aws_security_group" "RDS_allow_rule" {
  description = "Allow port 3306"
  vpc_id      = data.terraform_remote_state.backend.outputs.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "random_string" "rds_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "dbpass" {
  name  = var.database_name
  type  = "SecureString"
  value = random_string.rds_password.result
}