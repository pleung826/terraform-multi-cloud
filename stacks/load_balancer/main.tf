module "load_balancer" {
  for_each = local.load_balancers

  source = "../../modules/load_balancer"

  provider        = each.value.provider
  lb_type         = each.value.lb_type
  name            = each.value.name
  region          = each.value.region
  internal        = each.value.internal
  subnet_ids      = try(each.value.subnet_ids, [])
  security_groups = try(each.value.security_groups, [])
  vpc_id          = try(each.value.vpc_id, "")
  resource_group  = try(each.value.resource_group, "")
  public_ip_id    = try(each.value.public_ip_id, "")
  ip_address      = try(each.value.ip_address, "")
  listeners       = try(each.value.listeners, [])
  target_groups   = try(each.value.target_groups, {})

  tags = {
    Owner       = "infra-team"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }

  providers = {
    aws   = aws.dev
    azure = azurerm.dev
    gcp   = google.dev
  }
}
