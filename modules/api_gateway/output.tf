output "api_id" {
  value = local.is_aws
    ? aws_apigatewayv2_api.api[0].id
    : azurerm_api_management_api.api[0].id
}

output "endpoint" {
  value = local.is_aws
    ? aws_apigatewayv2_api.api[0].api_endpoint
    : null
}