variable "cloud" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "vpc_attachments" {
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
  }))
  default = {}
}

variable "peerings" {
  type = map(object({
    peer_account_id = string
    peer_region     = string
    peer_tgw_id     = string
    tags            = map(string)
  }))
  default = {}
}

variable "resource_group" {
  type    = string
  default = null
}

variable "virtual_hubs" {
  type = map(object({
    name           = string
    address_prefix = string
  }))
  default = {}
}

variable "hub_peerings" {
  type = map(object({
    source_hub_name               = string
    peer_hub_id                   = string
    allow_virtual_network_access  = bool
    allow_branch_to_branch_traffic = bool
    tags                          = map(string)
  }))
  default = {}
}

variable "route_tables" {
  type = map(object({
    name         = string
    associations = list(string)
    propagations = list(string)
    routes       = map(object({
      destination_cidr_block = string
      target_attachment      = string
    }))
    tags = map(string)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}