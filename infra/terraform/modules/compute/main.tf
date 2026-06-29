# ==========================================================
# Control Plane Node (K3s Server)
# ==========================================================

resource "aws_instance" "control_plane" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-${var.environment}-control-plane"
    Role = "control-plane"
  }
}

# ==========================================================
# Worker Nodes (K3s Agents)
# ==========================================================

resource "aws_instance" "workers" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-${var.environment}-worker-${count.index}"
    Role = "worker"
  }
}
