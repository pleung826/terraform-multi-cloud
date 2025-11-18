output "storage_id" {
  value = local.is_aws
    ? aws_s3_bucket.bucket[0].id
    : azurerm_storage_container.container[0].id
}