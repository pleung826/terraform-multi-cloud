variable "apis" {
  type = map(object({
    path        = string
    method      = string
    integration = object({
      type     = string
      uri      = string
      timeout  = number
    })
  }))
  default = {
    "healthcheck" = {
      path   = "/health"
      method = "GET"
      integration = {
        type    = "HTTP"
        uri     = "https://dev-api.example.com/health"
        timeout = 30
      }
    },
    "orders" = {
      path   = "/orders"
      method = "POST"
      integration = {
        type    = "AWS_PROXY"
        uri     = "arn:aws:lambda:us-east-1:123456789012:function:dev-order-handler"
        timeout = 60
      }
    }
  }
}