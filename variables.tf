#Define Public Subnet CIDRs
variable "public_cidr_blocks" {
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

#VPC cidr for webserver
variable "vpc_cidr" {
  default     = "10.20.0.0/16"
  type        = string
  description = "VPC to host static website"
}

# Declare default tag for network resources
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Declare prefix for network resources
variable "prefix" {
  default     = "lab4"
  type        = string
  description = "Name prefix"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Default environment deployment"
}