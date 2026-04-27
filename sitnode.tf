# ─── SIT Managed Node Group ───────────────────────────────────────────────────

resource "aws_eks_node_group" "sit" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-sit-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  # Instance configuration
  instance_types = [var.sit_instance_type]
  disk_size      = var.sit_disk_size
  ami_type       = "AL2_x86_64"   # Amazon Linux 2 — change to AL2_ARM_64 for Graviton
  capacity_type  = "ON_DEMAND"

  # Node count — desired/min/max all set to 2 as per requirement
  scaling_config {
    desired_size = var.sit_desired_size   # 2
    min_size     = var.sit_min_size       # 1
    max_size     = var.sit_max_size       # 2
  }

  # Keep nodes in service during updates — replaces one at a time
  update_config {
    max_unavailable = 1
  }

  # Remote access (optional – remove if not needed)
  # remote_access {
  #   ec2_ssh_key = "your-key-pair-name"
  #   source_security_group_ids = [aws_security_group.sit_sg.id]
  # }

  # Kubernetes labels that pods can use for nodeSelector
  labels = {
    "environment" = "sit"
    "node-group"  = "sit"
    "role"        = "worker"
  }

  # Taints — pods must tolerate this to be scheduled on SIT nodes
  taint {
    key    = "environment"
    value  = "sit"
    effect = "NO_SCHEDULE"
  }

  # Ensure the IAM policies are attached before the node group is created
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]

  tags = merge(var.tags, {
    Name                                                = "${var.cluster_name}-sit-node"
    Environment                                         = "sit"
    "k8s.io/cluster-autoscaler/enabled"                = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}"    = "owned"
  })

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
