variable "region" {
  description = "Please provide a region name"
  type        = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "tags" {
  description = "Please provide a tag for resources"
  type        = map(any)
  default     = {}
}