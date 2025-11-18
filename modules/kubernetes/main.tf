locals {
  is_aws   = var.cloud == "aws"
  is_azure = var.cloud == "azure"
}

# AWS EKS Cluster
resource "aws_eks_cluster" "eks" {
  count = local.is_aws ? 1 : 0
  name  = var.cluster_name
  role_arn = "arn:aws:iam::123456789012:role/EKSClusterRole" # replace with dynamic input
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  version = var.version
  tags    = var.tags
}

resource "aws_eks_node_group" "nodes" {
  for_each = local.is_aws ? var.node_groups : {}

  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = each.key
  node_role_arn   = "arn:aws:iam::123456789012:role/EKSNodeRole" # replace with dynamic input
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }
  labels = each.value.labels
  tags   = var.tags
}

# Azure AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  count = local.is_azure ? 1 : 0
  name                = var.cluster_name
  location            = var.region
  resource_group_name = var.resource_group
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.version

  default_node_pool {
    name       = "default"
    node_count = var.node_pools["default"].node_count
    vm_size    = var.node_pools["default"].vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Access Roles (abstracted)
module "access_roles" {
  source = "../kubernetes/access_roles"
  cloud  = var.cloud
  cluster_name = var.cluster_name
  access_roles = var.access_roles
}