variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for worker nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for EKS control plane ENIs"
  type        = list(string)
}

# ─── UAT Node Group ───────────────────────────────────────────────────────────
variable "uat_instance_type" {
  description = "EC2 instance type for UAT node group"
  type        = string
  default     = "t3.medium"
}

variable "uat_disk_size" {
  description = "Root EBS disk size (GiB) for UAT nodes"
  type        = number
  default     = 20
}

variable "uat_desired_size" {
  description = "Desired number of UAT worker nodes"
  type        = number
  default     = 2
}

variable "uat_min_size" {
  description = "Minimum number of UAT worker nodes"
  type        = number
  default     = 1
}

variable "uat_max_size" {
  description = "Maximum number of UAT worker nodes"
  type        = number
  default     = 2
}

# ─── SIT Node Group ───────────────────────────────────────────────────────────
variable "sit_instance_type" {
  description = "EC2 instance type for SIT node group"
  type        = string
  default     = "t3.medium"
}

variable "sit_disk_size" {
  description = "Root EBS disk size (GiB) for SIT nodes"
  type        = number
  default     = 20
}

variable "sit_desired_size" {
  description = "Desired number of SIT worker nodes"
  type        = number
  default     = 2
}

variable "sit_min_size" {
  description = "Minimum number of SIT worker nodes"
  type        = number
  default     = 1
}

variable "sit_max_size" {
  description = "Maximum number of SIT worker nodes"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "eks-cluster"
    ManagedBy   = "terraform"
    Owner       = "devops"
  }
}
