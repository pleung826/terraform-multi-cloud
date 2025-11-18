variable "record_sets" {
  type = map(object({
    type    = string
    ttl     = number
    records = list(string)
  }))
  default = {
    "www" = {
      type    = "A"
      ttl     = 300
      records = ["192.0.2.1"]
    },
    "api" = {
      type    = "CNAME"
      ttl     = 300
      records = ["api.dev.example.com"]
    }
  }
}
