resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block       # string variable
  instance_tenancy = var.instance_tenancy # string variable
  
  tags             = {
    Name   = "main"
  }
}
