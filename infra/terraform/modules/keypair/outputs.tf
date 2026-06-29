# ==========================================================
# Key Pair Outputs
# ==========================================================

output "key_name" {
  description = "EC2 Key Pair name"
  value       = aws_key_pair.main.key_name
}