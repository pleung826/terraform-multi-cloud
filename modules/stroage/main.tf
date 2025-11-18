locals {
  is_aws   = var.cloud == "aws"
  is_azure = var.cloud == "azure"
  destination_arn = var.replication.enabled && local.is_aws
    ? "arn:aws:s3:::${var.replication.destination}"
    : null
}

# AWS S3 Bucket
resource "aws_s3_bucket" "bucket" {
  count  = local.is_aws ? 1 : 0
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = local.is_aws && var.versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count = local.is_aws && var.replication.enabled ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  role   = "arn:aws:iam::123456789012:role/s3-replication-role" # Replace with input or output

  rules {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = local.destination_arn
      storage_class = "STANDARD"
    }

    filter {
      prefix = ""
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = local.is_aws && length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket[0].id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = rule.value.prefix
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      expiration {
        days = rule.value.expiration.days
      }
    }
  }
}

# Azure Blob Storage
resource "azurerm_storage_container" "container" {
  count                 = local.is_azure ? 1 : 0
  name                  = var.container_name
  storage_account_name  = var.storage_account
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "policy" {
  count                = local.is_azure && length(var.lifecycle_rules) > 0 ? 1 : 0
  name                 = "policy-${var.container_name}"
  resource_group_name  = var.resource_group
  storage_account_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/${var.resource_group}/providers/Microsoft.Storage/storageAccounts/${var.storage_account}"

  rule {
    for_each = var.lifecycle_rules
    name     = each.value.name
    enabled  = each.value.enabled
    filters  = each.value.filters
    actions  = each.value.actions
  }
}