region = "us-east-1"
cidr   = "10.0.0.0/16"

azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]



tags = {
  Name      = "Terraform-project"
  createdBy = "Team-1"
}