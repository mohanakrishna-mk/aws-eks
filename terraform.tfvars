# ── Copy this file to terraform.tfvars and fill in your values ────────────────

aws_region      = "ap-south-1"
cluster_name    = "my-eks-cluster"
cluster_version = "1.29"

vpc_id             = "vpc-0abc1234def56789"
private_subnet_ids = ["subnet-0aaa1111", "subnet-0bbb2222"]
public_subnet_ids  = ["subnet-0ccc3333", "subnet-0ddd4444"]

# UAT Node Group
uat_instance_type = "t3.medium"
uat_disk_size     = 20
uat_desired_size  = 2
uat_min_size      = 1
uat_max_size      = 2

# SIT Node Group
sit_instance_type = "t3.medium"
sit_disk_size     = 20
sit_desired_size  = 2
sit_min_size      = 1
sit_max_size      = 2

tags = {
  Project   = "eks-cluster"
  ManagedBy = "terraform"
  Owner     = "devops"
}
