variable "cloud" {
  type = string
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "resource_group" {
  type    = string
  default = null
}

variable "location" {
  type    = string
  default = null
}

variable "groups" {
  type = map(object({
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
}