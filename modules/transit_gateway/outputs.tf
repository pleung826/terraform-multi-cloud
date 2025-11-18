output "gateway_id" {
  value = local.is_aws
    ? aws_ec2_transit_gateway.tgw[0].id
    : azurerm_virtual_wan.vwan[0].id
}

output "attachment_ids" {
  value = local.is_aws
    ? { for k, v in aws_ec2_transit_gateway_vpc_attachment.attachments : k => v.id }
    : { for k, v in azurerm_virtual_hub.hubs : k => v.id }
}

output "peering_attachment_ids" {
  value = local.is_aws
    ? { for k, v in aws_ec2_transit_gateway_peering_attachment.peerings : k => v.id }
    : {}
}

output "azure_hub_peering_ids" {
  value = local.is_azure
    ? { for k, v in azurerm_virtual_hub_connection.peerings : k => v.id }
    : {}
}

output "route_table_ids" {
  value = local.is_aws
    ? { for k, v in aws_ec2_transit_gateway_route_table.rt : k => v.id }
    : { for k, v in azurerm_virtual_hub_route_table.rt : k => v.id }
}