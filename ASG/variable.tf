variable "domain_name" {
  description = "Please provide a domain name"
  type        = string
}
variable "zone_id" {
  description = "Please provide a domain name"
  type        = string
}

variable "tags" {
  description = "Please provide a tag for resources"
  type        = map(any)
  default     = {}
}
