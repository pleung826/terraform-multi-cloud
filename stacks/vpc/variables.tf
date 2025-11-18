variable "region" {
  type = "string"
}

variable "project" {
  type = "string"
}

variable "cidr_block" {
  type    = string
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    type       = string # "public" or "private"
    tags       = map(string)
  }))
  # default = {
  #   "public-a" = {
  #     cidr_block = "10.0.1.0/24"
  #     az         = "us-east-1a"
  #     type       = "public"
  #     tags       = { "role" = "ingress" }
  #   },
  #   "private-a" = {
  #     cidr_block = "10.0.2.0/24"
  #     az         = "us-east-1a"
  #     type       = "private"
  #     tags       = { "role" = "app" }
  #   }
  # }
}

variable "enable_nat" {
  type    = bool
  default = true
}

variable "enable_dns" {
  type    = bool
  default = true
}

variable "peerings" {
  type = list(object({
    peer_vpc_id     = string
    peer_account_id = string
    peer_region     = string
    auto_accept     = bool
  }))
  default = []
}

variable "flow_logs" {
  type = object({
    enabled        = bool
    log_destination = string
    traffic_type   = string # "ALL", "ACCEPT", "REJECT"
  })
  default = {
    enabled        = true
    log_destination = "arn:aws:logs:us-east-1:123456789012:log-group:/vpc/flowlogs"
    traffic_type   = "ALL"
  }
}
