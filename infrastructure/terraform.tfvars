
# =============================
# General Environment Settings
# =============================
region = "eu-central-1"                  # AWS region
environment = "eran-counter"          # Environment name

# =============================
# VPC & Subnet Configuration
# =============================
vpc_cidr = "10.1.0.0/16"              # VPC CIDR block
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]   # Public subnets
private_subnet_cidrs = ["10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24"] # Private subnets
azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]                       # Availability zones
vpc_name = "eran-counter_vpc"           # VPC name

# =============================
# EKS & ALB Configuration
# =============================
eks_cluster_name = "eran-counter-eks"   # EKS cluster name

alb_name = "eran-counter-alb"           # ALB name
alb_internal = false                    # ALB is public
alb_security_groups = []                # ALB security groups
alb_enable_deletion_protection = false  # ALB deletion protection
alb_tags = { Name = "eran-counter-alb" }# ALB tags

alb_target_group_name = "eran-counter-tg"      # Target group name
alb_target_group_port = 80                     # Target group port
alb_target_group_protocol = "HTTP"             # Target group protocol
alb_target_type = "ip"                         # Target type

alb_health_check_path = "/"                    # Health check path
alb_health_check_protocol = "HTTP"             # Health check protocol
alb_health_check_matcher = "200-399"           # Health check matcher
alb_health_check_interval = 30                 # Health check interval (seconds)
alb_health_check_timeout = 5                   # Health check timeout (seconds)
alb_health_check_healthy_threshold = 2         # Healthy threshold
alb_health_check_unhealthy_threshold = 2       # Unhealthy threshold

alb_listener_port = 80                         # Listener port
alb_listener_protocol = "HTTP"                 # Listener protocol

# =============================
# ECR Configuration
# =============================
ecr_repository_name = "eran-counter-service"   # ECR repository name

# =============================
# EKS Node Group Configuration
# =============================
node_group_min_size    = 3                     # Minimum node group size
node_group_max_size    = 5                     # Maximum node group size
node_group_desired_size = 3                    # Desired node group size
node_instance_type     = "t3.medium"           # Node instance type
