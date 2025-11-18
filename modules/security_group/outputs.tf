output "group_ids" {
  value = local.is_aws ? {
    for k, sg in aws_security_group.sg : k => sg.id
  } : {
    for k, sg in azurerm_network_security_group.nsg : k => sg.id
  }
}