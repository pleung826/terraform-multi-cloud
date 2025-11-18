locals {
  is_aws   = var.cloud == "aws"
  is_azure = var.cloud == "azure"
}

# AWS API Gateway v2
resource "aws_apigatewayv2_api" "api" {
  count       = local.is_aws ? 1 : 0
  name        = var.name
  protocol_type = "HTTP"
  description = var.description
  tags        = var.tags
}

resource "aws_apigatewayv2_stage" "stage" {
  count       = local.is_aws ? 1 : 0
  api_id      = aws_apigatewayv2_api.api[0].id
  name        = var.stage_name
  auto_deploy = true
  tags        = var.tags
}

resource "aws_apigatewayv2_integration" "integrations" {
  for_each = local.is_aws ? {
    for k, v in var.routes : k => v if contains(["lambda", "http"], v.integration.type)
  } : {}

  api_id           = aws_apigatewayv2_api.api[0].id
  integration_type = upper(each.value.integration.type)
  integration_uri  = each.value.integration.type == "lambda" ? each.value.integration.lambda_arn : each.value.integration.url
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "routes" {
  for_each = local.is_aws ? var.routes : {}

  api_id    = aws_apigatewayv2_api.api[0].id
  route_key = "${each.value.method} ${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.integrations[each.key].id}"
}

# Azure API Management (simplified)
resource "azurerm_api_management_api" "api" {
  count               = local.is_azure ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group
  api_management_name = var.name
  revision            = "1"
  display_name        = var.name
  path                = "/"
  protocols           = ["https"]
  import {
    content_format = "swagger-link-json"
    content_value  = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/examples/v3.0/petstore.yaml"
  }
  tags = var.tags
}

# Optional: Add azurerm_api_management_api_operation for each route if needed