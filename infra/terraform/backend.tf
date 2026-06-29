terraform {
  backend "s3" {
    bucket         = "taskapp-apex-terraform-state"
    key            = "capstone-phoenix/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "taskapp-apex-terraform-state-lock"
    encrypt        = true
  }
}
