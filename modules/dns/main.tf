locals {
  is_aws   = var.cloud == "aws"
  is_azure = var.cloud == "azure"
}

# AWS Route 53 Zone
resource "aws_route53_zone" "zone" {
  count   = local.is_aws ? 1 : 0
  name    = var.zone_name
  comment = var.comment
  tags    = var.tags
}

resource "aws_route53_record" "records" {
  for_each = local.is_aws ? var.records : {}

  zone_id = aws_route53_zone.zone[0].id
  name    = "${each.key}.${var.zone_name}"
  type    = each.value.type
  ttl     = each.value.ttl
  records = [each.value.value]
}

# Azure DNS Zone
resource "azurerm_dns_zone" "zone" {
  count               = local.is_azure ? 1 : 0
  name                = var.zone_name
  resource_group_name = var.resource_group
  tags                = var.tags
}

resource "azurerm_dns_a_record" "a_records" {
  for_each = local.is_azure ? {
    for name, record in var.records : name => record
    if record.type == "A"
  } : {}

  name                = each.key
  zone_name           = azurerm_dns_zone.zone[0].name
  resource_group_name = var.resource_group
  ttl                 = each.value.ttl
  records             = [each.value.value]
}

resource "azurerm_dns_cname_record" "cname_records" {
  for_each = local.is_azure ? {
    for name, record in var.records : name => record
    if record.type == "CNAME"
  } : {}

  name                = each.key
  zone_name           = azurerm_dns_zone.zone[0].name
  resource_group_name = var.resource_group
  ttl                 = each.value.ttl
  record              = each.value.value
}