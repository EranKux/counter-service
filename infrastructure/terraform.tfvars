
# =============================
# General Environment Settings
# =============================
region = "eu-west-1"                  # AWS region
environment = "eran-counter"          # Environment name

# =============================
# VPC & Subnet Configuration
# =============================
vpc_cidr = "10.1.0.0/16"              # VPC CIDR block
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]   # Public subnets
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24"] # Private subnets
azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]                       # Availability zones
vpc_name = "eran-counter_vpc"           # VPC name

# =============================
# ECR Configuration
# =============================
ecr_repository_name = "eran-counter-service"   # ECR repository name

# =============================
# EKS Node Group Configuration
# =============================
eks_cluster_name = "eran-counter-eks"   # EKS cluster name
node_group_min_size    = 3                     # Minimum node group size
node_group_max_size    = 5                     # Maximum node group size
node_group_desired_size = 3                    # Desired node group size
node_instance_type     = "t3.micro"           # Node instance type
