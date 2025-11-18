variable "region" {
  description = "Deployment region for the load balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for AWS load balancers"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = "List of public subnet IDs for AWS"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnet IDs for AWS"
  type        = list(string)
  default     = []
}

variable "acm_cert_arn" {
  description = "ACM certificate ARN for HTTPS listeners"
  type        = string
  default     = ""
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
  default     = ""
}

variable "azure_public_ip_id" {
  description = "Azure public