variable "cloud" {
  type = string
}

# AWS
variable "bucket_name" {
  type    = string
  default = null
}

variable "versioning" {
  type    = bool
  default = false
}

variable "replication" {
  type = object({
    enabled     = bool
    destination = string
  })
  default = {
    enabled     = false
    destination = ""
  }
}

# Azure
variable "container_name" {
  type    = string
  default = null
}

variable "storage_account" {
  type    = string
  default = null
}

variable "resource_group" {
  type    = string
  default = null
}

variable "access_tier" {
  type    = string
  default = "Hot"
}

# Shared
variable "lifecycle_rules" {
  type    = any
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}