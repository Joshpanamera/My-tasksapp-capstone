# ==========================================================
# Project
# ==========================================================

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

# ==========================================================
# AWS
# ==========================================================

variable "aws_region" {
  type = string
}

variable "availability_zone" {
  type = string
}

# ==========================================================
# Network
# ==========================================================

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

# ==========================================================
# Compute
# ==========================================================

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}
