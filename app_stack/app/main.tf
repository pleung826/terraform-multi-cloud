module "apps" {
  for_each = var.apps

  source = "../../modules/app_stack" # or "./modules/app_stack" if nested

  app = {
    name      = each.key
    cloud     = each.value.cloud
    cluster   = each.value.cluster
    namespace = each.value.namespace
    image     = each.value.image
    replicas  = each.value.replicas
    expose    = each.value.expose
    resources = each.value.resources
    database  = each.value.database
    cache     = each.value.cache
    tags      = each.value.tags
  }
}