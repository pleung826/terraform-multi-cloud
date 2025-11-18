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

variable "stage_name" {
  type    = string
  default = "default"
}

variable "resource_group" {
  type    = string
  default = null
}

variable "api_type" {
  type    = string
  default = "http" # Azure only
}

variable "routes" {
  type = map(object({
    path   = string
    method = string
    integration = optional(object({
      type       = string         # "lambda" or "http"
      lambda_arn = optional(string)
      url        = optional(string)
    }))
    backend_url = optional(string) # Azure only
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}