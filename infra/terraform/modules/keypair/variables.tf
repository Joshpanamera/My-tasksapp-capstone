# ==========================================================
# Key Pair Module Variables
# ==========================================================

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
}