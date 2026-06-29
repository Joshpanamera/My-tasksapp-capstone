provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Joshua Kpejoh Tam"
    }
  }

  retry_mode  = "standard"
  max_retries = 4
}
