module "vpc" {
  source = "../../modules/vpc"

  environment     = "dev"
  region          = var.region
  project         = var.project
  cidr_block      = var.cidr_block
  subnets         = var.subnets
  enable_nat      = var.enable_nat
  enable_dns      = var.enable_dns
  peerings        = var.peerings
  flow_logs       = var.flow_logs

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