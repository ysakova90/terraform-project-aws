variable "cidr_block" {
  description = "Please provide a cidr block"
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