# ==========================================================
# Kubernetes Control Plane IP
# ==========================================================

output "control_plane_public_ip" {
  description = "Public IP of the K3s control plane"
  value       = module.compute.control_plane_public_ip
}

# ==========================================================
# Kubernetes Worker Nodes IPs
# ==========================================================

output "worker_public_ips" {
  description = "Public IPs of K3s worker nodes"
  value       = module.compute.worker_public_ips
}

# ==========================================================
# Optional: private IP (useful for internal comms/debugging)
# ==========================================================

output "control_plane_private_ip" {
  value = module.compute.control_plane_private_ip
}
