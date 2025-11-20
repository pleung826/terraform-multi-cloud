# AWS RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  count                     = var.provider == "aws" ? 1 : 0
  identifier                = var.name
  engine                    = "postgres"
  engine_version            = var.db_config.engine_version
  instance_class            = var.db_config.instance_class
  allocated_storage         = var.db_config.storage_gb
  username                  = var.db_config.username
  password                  = var.db_config.password
  vpc_security_group_ids    = var.subnet_ids
  db_subnet_group_name      = aws_db_subnet_group.this[0].name
  backup_retention_period   = var.db_config.backup_retention
  publicly_accessible       = var.db_config.publicly_accessible
  skip_final_snapshot       = true
  tags                      = var.tags
}

resource "aws_db_subnet_group" "this" {
  count      = var.provider == "aws" ? 1 : 0
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

# Azure PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  count               = var.provider == "azure" ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.region
  version             = var.db_config.engine_version
  administrator_login          = var.db_config.username
  administrator_password       = var.db_config.password
  storage_mb                   = var.db_config.storage_gb * 1024
  sku_name                     = var.db_config.instance_class
  backup_retention_days        = var.db_config.backup_retention
  zone                         = "1"
  tags                         = var.tags

  delegated_subnet_id          = var.subnet_ids[0]
  private_dns_zone_id          = null
}

# GCP Cloud SQL PostgreSQL
resource "google_sql_database_instance" "postgres" {
  count               = var.provider == "gcp" ? 1 : 0
  name                = var.name
  region              = var.region
  database_version    = "POSTGRES_${var.db_config.engine_version}"
  settings {
    tier              = var.db_config.instance_class
    disk_size         = var.db_config.storage_gb
    backup_configuration {
      enabled         = true
      retention_count = var.db_config.backup_retention
    }
    ip_configuration {
      ipv4_enabled    = var.db_config.publicly_accessible
    }
  }
  root_password       = var.db_config.password
}

resource "google_sql_user" "postgres" {
  count     = var.provider == "gcp" ? 1 : 0
  name      = var.db_config.username
  instance  = google_sql_database_instance.postgres[0].name
  password  = var.db_config.password
}