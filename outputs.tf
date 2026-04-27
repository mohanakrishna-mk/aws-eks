# ─── EKS Cluster Outputs ──────────────────────────────────────────────────────

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded cluster CA certificate"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = aws_eks_cluster.main.version
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider (used for IRSA)"
  value       = aws_iam_openid_connect_provider.eks.arn
}

# ─── Node Group Outputs ────────────────────────────────────────────────────────

output "uat_node_group_arn" {
  description = "ARN of the UAT node group"
  value       = aws_eks_node_group.uat.arn
}

output "uat_node_group_status" {
  description = "Status of the UAT node group"
  value       = aws_eks_node_group.uat.status
}

output "sit_node_group_arn" {
  description = "ARN of the SIT node group"
  value       = aws_eks_node_group.sit.arn
}

output "sit_node_group_status" {
  description = "Status of the SIT node group"
  value       = aws_eks_node_group.sit.status
}

# ─── IAM Outputs ──────────────────────────────────────────────────────────────

output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arn" {
  description = "ARN of the worker node IAM role"
  value       = aws_iam_role.node_group_role.arn
}

# ─── Security Group Outputs ───────────────────────────────────────────────────

output "cluster_sg_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster_sg.id
}

output "nodes_sg_id" {
  description = "ID of the shared worker node security group"
  value       = aws_security_group.eks_nodes_sg.id
}

output "uat_sg_id" {
  description = "ID of the UAT-specific security group"
  value       = aws_security_group.uat_sg.id
}

output "sit_sg_id" {
  description = "ID of the SIT-specific security group"
  value       = aws_security_group.sit_sg.id
}

# ─── kubeconfig helper ────────────────────────────────────────────────────────

output "kubeconfig_command" {
  description = "Run this command to update your local kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}
