module "security_group" {
  source = "../../modules/security_group"

  environment     = "dev"
  region          = var.region
  project         = var.project
  group_name      = var.group_name
  group_rules     = var.group_rules
  vpc_id          = var.vpc_id
  attach_to_roles = var.attach_to_roles # optional IAM integration

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