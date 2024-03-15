variable "region" {
  description = "Please provide a region"
  type        = string
  default     = ""
}
variable "cidr_block" {
  description = "Please provide a cidr block"
  type        = string
  default     = ""
}
variable "instance_tenancy" {
  description = "please provide instance_tenancy information"
  type        = string
  default     = ""
}
variable "tags" {
  description = "Please specify tags"
  type        = map(any)
  default     = {}
}
variable "public_subnet1" {
  description = "Please provide cidr block for subnet1"
  type        = string
  default     = ""
}
variable "public_subnet2" {
  description = "Please provide cidr block for subnet2"
  type        = string
  default     = ""
}
variable "public_subnet3" {
  description = "Please provide cidr block for subnet3"
  type        = string
  default     = ""
}
variable "private_subnet1" {
  description = "Please provide cidr block for subnet1"
  type        = string
  default     = ""
}
variable "private_subnet2" {
  description = "Please provide cidr block for subnet2"
  type        = string
  default     = ""
}
variable "private_subnet3" {
  description = "Please provide cidr block for subnet3"
  type        = string
  default     = ""
}
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
} 
# Attach Internet Gateway to Public Subnets
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public_subnet_rt.id
}