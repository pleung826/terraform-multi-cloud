variable "apps" {
  type = map(object({
    cloud        = string
    cluster      = string
    namespace    = string
    image        = string
    replicas     = number
    expose = object({
      type     = string
      port     = number
      protocol = string
      dns_name = string
    })
    resources = object({
      cpu    = string
      memory = string
    })
    database = optional(object({
      type    = string
      version = string
      storage = string
    }))
    cache = optional(object({
      type    = string
      version = string
      memory  = string
    }))
    tags = map(string)
  }))
}