module "kubernetes" {
  for_each = var.kubernetes_clusters

  source = "../../modules/kubernetes"

  provider         = each.value.provider
  region           = each.value.region
  environment      = each.value.environment
  project          = each.value.project
  cluster_name     = each.value.cluster_name
  cluster_version  = each.value.cluster_version
  subnet_ids       = try(each.value.subnet_ids, [])
  vpc_id           = try(each.value.vpc_id, "")
  node_pools       = each.value.node_pools
  network_config   = each.value.network_config
  addons           = each.value.addons
  identity_config  = each.value.identity_config

  tags = {
    Owner       = "infra-team"
    Environment = each.value.environment
    ManagedBy   = "Terraform"
  }

  providers = {
    aws   = aws.dev
    azure = azurerm.dev
    gcp   = google.dev
  }
}
