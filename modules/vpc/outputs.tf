output "network_id" {
  value = local.is_aws
    ? aws_vpc.vpc[0].id
    : azurerm_virtual_network.vnet[0].id
}

output "subnet_ids" {
  value = local.is_aws
    ? { for k, v in aws_subnet.subnets : k => v.id }
    : { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "peering_ids" {
  value = local.is_aws
    ? { for k, v in aws_vpc_peering_connection.peerings : k => v.id }
    : { for k, v in azurerm_virtual_network_peering.peerings : k => v.id }
}

output "security_group_ref" {
  value = var.security_group_ref
}