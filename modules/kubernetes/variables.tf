variable "cloud" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "version" {
  type = string
}

variable "vpc_id" {
  type = string
  default = null
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "resource_group" {
  type = string
  default = null
}

variable "subnet_id" {
  type = string
  default = null
}

variable "node_groups" {
  type = map(object({
    instance_type = string
    desired_size  = number
    min_size      = number
    max_size      = number
    labels        = map(string)
  }))
  default = {}
}

variable "node_pools" {
  type = map(object({
    vm_size    = string
    node_count = number
    min_count  = number
    max_count  = number
    mode       = string
    labels     = map(string)
  }))
  default = {}
}

variable "access_roles" {
  type = map(object({
    type         = string
    principal    = string
    namespace    = string
    cluster_role = string
  }))
  default = {}
}

variable "enable_cluster_autoscaler" {
  type    = bool
  default = false
}

variable "enable_metrics_server" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}