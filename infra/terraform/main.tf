data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
# ==========================================================
# Network Module
# ==========================================================

module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

# ==========================================================
# Security Group Module
# ==========================================================

module "security_group" {
  source = "./modules/security_group"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
}

# ==========================================================
# Compute Module
# ==========================================================

module "compute" {
  source = "./modules/compute"

  project_name  = var.project_name
  environment   = var.environment
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id         = module.network.public_subnet_id
  security_group_id = module.security_group.security_group_id

  ami_id = data.aws_ami.ubuntu.id
}
