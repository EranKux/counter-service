provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  vpc_name             = var.vpc_name
  environment          = var.environment
}

module "alb" {
  source                     = "./modules/alb"
  name                       = var.alb_name
  internal                   = var.alb_internal
  security_groups            = [module.vpc.alb_default_sg_id]
  subnets                    = module.vpc.public_subnet_ids
  enable_deletion_protection = var.alb_enable_deletion_protection
  tags                       = var.alb_tags
  target_group_name                = var.alb_target_group_name
  target_group_port                = var.alb_target_group_port
  target_group_protocol            = var.alb_target_group_protocol
  vpc_id                           = module.vpc.vpc_id
  target_type                      = var.alb_target_type
  health_check_path                = var.alb_health_check_path
  health_check_protocol            = var.alb_health_check_protocol
  health_check_matcher             = var.alb_health_check_matcher
  health_check_interval            = var.alb_health_check_interval
  health_check_timeout             = var.alb_health_check_timeout
  health_check_healthy_threshold   = var.alb_health_check_healthy_threshold
  health_check_unhealthy_threshold = var.alb_health_check_unhealthy_threshold
  listener_port                    = var.alb_listener_port
  listener_protocol                = var.alb_listener_protocol
}

module "redis" {
  source                = "./modules/redis"
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  eks_security_group_id = aws_security_group.eks_nodes.id
  private_subnet_ids    = module.vpc.private_subnet_ids
}

resource "aws_security_group" "eks_nodes" {
  name_prefix = "eks-nodes-"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "EKS Nodes SG"
    Environment = var.environment
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "21.15.1"
  name            = var.eks_cluster_name
  kubernetes_version = "1.35"
  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id
  endpoint_public_access  = false
  enable_irsa             = true
  eks_managed_node_groups = {
    default = {
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      subnet_ids     = module.vpc.private_subnet_ids
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
      iam_role_arn   = aws_iam_role.eks_node_group.arn
      ami_type       = "AL2023_x86_64_STANDARD"
      additional_security_group_ids = [aws_security_group.eks_nodes.id]
      update_config = {
        max_unavailable_percentage = 33
      }
      tags = {
        Environment = var.environment
        Terraform   = "true"
      }
    }
  }
  upgrade_policy = {
    support_type = "STANDARD"
  }
}

  resource "aws_iam_role" "eks_node_group" {
    name = "eran-eks-node-group-role"
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
  }

  resource "aws_iam_role_policy_attachment" "worker_node" {
    for_each = toset([
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ])
    role       = aws_iam_role.eks_node_group.name
    policy_arn = each.value
  }

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.eks.cluster_name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = module.eks.cluster_name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = module.eks.cluster_name
  addon_name   = "kube-proxy"
}

resource "aws_ecr_repository" "my_app" {
  name = var.ecr_repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Environment = var.environment
  }
}