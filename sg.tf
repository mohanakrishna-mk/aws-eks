# ─── EKS Cluster Control Plane Security Group ────────────────────────────────

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-sg"
  })
}

# Allow control plane to receive traffic from worker nodes
resource "aws_security_group_rule" "cluster_inbound_from_nodes" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  security_group_id        = aws_security_group.eks_cluster_sg.id
  description              = "Allow nodes to communicate with cluster API"
}

# ─── Worker Node Security Group (shared by UAT and SIT) ──────────────────────

resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes (UAT + SIT)"
  vpc_id      = var.vpc_id

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodes-sg"
  })
}

# Nodes can talk to each other (required for pod-to-pod networking)
resource "aws_security_group_rule" "nodes_internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.eks_nodes_sg.id
  description       = "Allow inter-node communication"
}

# Nodes receive traffic from control plane (kubelet, kube-proxy, metrics)
resource "aws_security_group_rule" "nodes_inbound_from_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  security_group_id        = aws_security_group.eks_nodes_sg.id
  description              = "Allow control plane to reach nodes"
}

# Control plane can call kubelet API (port 443) on nodes
resource "aws_security_group_rule" "nodes_inbound_from_cluster_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  security_group_id        = aws_security_group.eks_nodes_sg.id
  description              = "Allow control plane HTTPS to nodes"
}

# ─── UAT-Specific Security Group ─────────────────────────────────────────────

resource "aws_security_group" "uat_sg" {
  name        = "${var.cluster_name}-uat-sg"
  description = "Additional security group for UAT node group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.tags, {
    Name        = "${var.cluster_name}-uat-sg"
    Environment = "uat"
  })
}

# ─── SIT-Specific Security Group ─────────────────────────────────────────────

resource "aws_security_group" "sit_sg" {
  name        = "${var.cluster_name}-sit-sg"
  description = "Additional security group for SIT node group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(var.tags, {
    Name        = "${var.cluster_name}-sit-sg"
    Environment = "sit"
  })
}
