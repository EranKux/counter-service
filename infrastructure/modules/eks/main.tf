module "eks" {
  source              = "terraform-aws-modules/eks/aws"
  version             = "21.15.1"
  name                = var.eks_cluster_name
  kubernetes_version  = "1.31"
  subnet_ids          = var.private_subnet_ids
  vpc_id              = var.vpc_id
  endpoint_public_access  = true
  enable_irsa             = true
  eks_managed_node_groups = {
    default = {
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      subnet_ids     = var.private_subnet_ids
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
      iam_role_arn   = var.eks_node_group_iam_role_arn
      ami_type       = "AL2023_x86_64_STANDARD"
      additional_security_group_ids = [var.eks_nodes_sg_id]
      update_config = {
        max_unavailable_percentage = 33
      }
      tags = {
        Environment = var.environment
        Terraform   = "true"
      }
      support_type = "STANDARD"
    }
  }
}
