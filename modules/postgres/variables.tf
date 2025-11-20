
variable "provider" {
  type    = string
  default = "aws" # or "azure", "gcp"
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "resource_group" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "db_config" {
  type = object({
    username           = string
    password           = string
    engine_version     = string
    instance_class     = string
    storage_gb         = number
    backup_retention   = number
    publicly_accessible = bool
  })
}

variable "tags" {
  type    = map(string)
  default = {}
}