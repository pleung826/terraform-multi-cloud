variable "region" {
  type = "string"
}

variable "project" {
  type = "string"
}

variable "buckets" {
  type = map(object({
    name              = string
    versioning        = bool
    public_access     = bool
    force_destroy     = bool
    replication_target = string # optional
  }))
  default = {
    "artifacts" = {
      name              = "dev-artifacts"
      versioning        = true
      public_access     = false
      force_destroy     = false
      replication_target = ""
    },
    "logs" = {
      name              = "dev-logs"
      versioning        = false
      public_access     = false
      force_destroy     = true
      replication_target = ""
    }
  }
}

variable "storage_class" {
  type    = string
  default = "STANDARD" # or "HOT"/"COOL"/"NEARLINE"/"COLDLINE" depending on provider
}

variable "lifecycle_rules" {
  type = list(object({
    bucket         = string
    prefix         = string
    enabled        = bool
    transition_days = number
    storage_class  = string
    expiration_days = number
  }))
  default = []
}

variable "access_policies" {
  type = map(object({
    bucket     = string
    principals = list(string)
    actions    = list(string)
    conditions = map(any)
  }))
  default = {}
}

variable "encryption" {
  type = object({
    enabled     = bool
    kms_key_id  = string
    algorithm   = string
  })
  default = {
    enabled     = true
    kms_key_id  = ""
    algorithm   = "AES256"
  }
}