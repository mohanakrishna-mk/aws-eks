# ─── Worker Node IAM Role (shared by UAT and SIT) ────────────────────────────

resource "aws_iam_role" "node_group_role" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-group-role"
  })
}

# ─── Attach AWS Managed Policies to Node Role ─────────────────────────────────

# Allows nodes to call EKS APIs
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Allows nodes to pull images from ECR
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Required for EKS networking (VPC CNI plugin)
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Required for SSM Session Manager access (optional but recommended)
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ─── Instance Profile (EC2 needs this to assume the role) ─────────────────────

resource "aws_iam_instance_profile" "node_group_profile" {
  name = "${var.cluster_name}-node-group-profile"
  role = aws_iam_role.node_group_role.name

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-group-profile"
  })
}
