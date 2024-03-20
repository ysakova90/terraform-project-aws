module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = "main"
  cidr               = var.cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  create_igw         = true

  tags = var.tags


  map_public_ip_on_launch = true

}

# Attach Internet Gateway to Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }

}

resource "aws_route_table" "private_route_table" {
  vpc_id = module.vpc.vpc_id
}