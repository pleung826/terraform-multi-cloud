variable "provider" {
  description = "Cloud provider: aws, azure, or gcp"
  type        = string
}

variable "lb_type" {
  description = "Load balancer type: application or network"
  type        = string
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "region" {
  description = "Deployment region"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
}

variable "subnet_ids" {
  description = "Subnets for the load balancer"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups (for ALB)"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID (for AWS)"
  type        = string
  default     = ""
}

variable "resource_group" {
  description = "Azure resource group"
  type        = string
  default     = ""
}

variable "public_ip_id" {
  description = "Azure public IP resource ID"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "GCP reserved IP address"
  type        = string
  default     = ""
}

variable "listeners" {
  description = "Listener configuration"
  type = list(object({
    port            = number
    protocol        = string
    target_group    = string
    ssl_policy      = string
    certificate_arn = string
  }))
}

variable "target_groups" {
  description = "Target group definitions"
  type = map(object({
    port     = number
    protocol = string
    targets  = list(object({
      id   = string
      port = number
    }))
    health_check = object({
      path                = string
      protocol            = string
      interval            = number
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
    })
  }))
}