variable "cloud" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "resource_group" {
  type    = string
  default = null
}

variable "comment" {
  type    = string
  default = ""
}

variable "records" {
  type = map(object({
    type  = string
    ttl   = number
    value = string
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}