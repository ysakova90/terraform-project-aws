resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block       # string variable
  instance_tenancy = "default" # string variable
  tags             = {
    Name = "main"
  }
}
