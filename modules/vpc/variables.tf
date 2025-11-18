variable "cloud" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "resource_group" {
  type    = string
  default = null
}

variable "subnets" {
  type = map(object({
    cidrs = list(string)
    azs   = optional(list(string)) # AWS only
  }))
  default = {}
}

variable "peerings" {
  type = map(object({
    peer_vpc_id                   = optional(string) # AWS
    peer_vnet_id                  = optional(string) # Azure
    auto_accept                   = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_virtual_network_access = optional(bool)
    tags                          = map(string)
  }))
  default = {}
}

variable "security_group_ref" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}