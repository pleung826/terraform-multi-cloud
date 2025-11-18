locals {
  is_aws   = var.cloud == "aws"
  is_azure = var.cloud == "azure"
}

# AWS Security Groups
resource "aws_security_group" "sg" {
  for_each = local.is_aws ? var.groups : {}

  name        = each.key
  description = each.value.description
  vpc_id      = var.vpc_id
  tags        = each.value.tags
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.is_aws ? {
    for sg_name, sg in var.groups :
    "${sg_name}-ingress" => {
      sg_name = sg_name
      rules   = sg.ingress
    }
  } : {}

  count       = length(each.value.rules)
  type        = "ingress"
  from_port   = each.value.rules[count.index].from_port
  to_port     = each.value.rules[count.index].to_port
  protocol    = each.value.rules[count.index].protocol
  cidr_blocks = each.value.rules[count.index].cidr_blocks
  security_group_id = aws_security_group.sg[each.value.sg_name].id
}

resource "aws_security_group_rule" "egress" {
  for_each = local.is_aws ? {
    for sg_name, sg in var.groups :
    "${sg_name}-egress" => {
      sg_name = sg_name
      rules   = sg.egress
    }
  } : {}

  count       = length(each.value.rules)
  type        = "egress"
  from_port   = each.value.rules[count.index].from_port
  to_port     = each.value.rules[count.index].to_port
  protocol    = each.value.rules[count.index].protocol
  cidr_blocks = each.value.rules[count.index].cidr_blocks
  security_group_id = aws_security_group.sg[each.value.sg_name].id
}

# Azure NSGs
resource "azurerm_network_security_group" "nsg" {
  for_each = local.is_azure ? var.groups : {}

  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group
  tags                = each.value.tags
}

resource "azurerm_network_security_rule" "ingress" {
  for_each = local.is_azure ? {
    for sg_name, sg in var.groups :
    "${sg_name}-ingress" => {
      sg_name = sg_name
      rules   = sg.ingress
    }
  } : {}

  count       = length(each.value.rules)
  name        = "${each.value.sg_name}-ingress-${count.index}"
  priority    = 100 + count.index
  direction   = "Inbound"
  access      = "Allow"
  protocol    = each.value.rules[count.index].protocol
  source_port_range      = "*"
  destination_port_range = "${each.value.rules[count.index].from_port}-${each.value.rules[count.index].to_port}"
  source_address_prefixes = each.value.rules[count.index].cidr_blocks
  destination_address_prefix = "*"
  network_security_group_name = azurerm_network_security_group.nsg[each.value.sg_name].name
  resource_group_name         = var.resource_group
}

resource "azurerm_network_security_rule" "egress" {
  for_each = local.is_azure ? {
    for sg_name, sg in var.groups :
    "${sg_name}-egress" => {
      sg_name = sg_name
      rules   = sg.egress
    }
  } : {}

  count       = length(each.value.rules)
  name        = "${each.value.sg_name}-egress-${count.index}"
  priority    = 200 + count.index
  direction   = "Outbound"
  access      = "Allow"
  protocol    = each.value.rules[count.index].protocol
  source_port_range      = "*"
  destination_port_range = "${each.value.rules[count.index].from_port}-${each.value.rules[count.index].to_port}"
  source_address_prefixes = each.value.rules[count.index].cidr_blocks
  destination_address_prefix = "*"
  network_security_group_name = azurerm_network_security_group.nsg[each.value.sg_name].name
  resource_group_name         = var.resource_group
}