# ==========================================================
# Security Group
# ==========================================================

resource "aws_security_group" "k3s" {
  name        = "${var.project_name}-${var.environment}-k3s-sg"
  description = "Security group for K3s cluster"
  vpc_id      = var.vpc_id

  # ==========================================================
  # Inbound Rules
  # ==========================================================

  # SSH
  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server
  ingress {
    description = "Kubernetes API"

    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal communication between K3s nodes
  ingress {
    description = "Internal K3s communication"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    self = true
  }

  # ==========================================================
  # Outbound Rules
  # ==========================================================

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-k3s-sg"
  }
}
