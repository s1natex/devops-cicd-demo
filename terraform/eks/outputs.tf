output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS API endpoint"
}

output "region" {
  value       = var.aws_region
  description = "Region"
}

output "node_group_role_arn" {
  value       = module.eks.eks_managed_node_groups["default"].iam_role_arn
  description = "Managed node group role ARN"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}
