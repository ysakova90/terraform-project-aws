region           = "eu-west-2"
cidr_block       = "10.0.0.0/16"
instance_tenancy = "default"
public_subnet1    = "10.0.1.0/24"
public_subnet2    = "10.0.2.0/24"


tags = {
  Name      = "london"
  region    = "london"
  dept      = "IT"
  createdBy = "devops"
}