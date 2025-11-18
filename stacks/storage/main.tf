module "storage" {
  source = "../../modules/storage"

  environment     = "dev"
  region          = var.region
  project         = var.project
  storage_class   = var.storage_class
  buckets         = var.buckets
  lifecycle_rules = var.lifecycle_rules
  access_policies = var.access_policies
  encryption      = var.encryption

  providers = {
    aws   = aws.dev
    azure = azurerm.dev
    gcp   = google.dev
  }

  tags = {
    Owner       = "infra-team"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}