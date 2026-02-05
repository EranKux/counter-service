variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "Environment tag for resources (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "counter-service-vpc"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "counter-service-eks"
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
  default     = "counter-service-alb"
}

variable "alb_internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "alb_security_groups" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
  default     = []
}

variable "alb_enable_deletion_protection" {
  description = "Enable deletion protection on the ALB"
  type        = bool
  default     = false
}

variable "alb_tags" {
  description = "Tags to apply to the ALB and related resources"
  type        = map(string)
  default     = { Name = "counter-service-alb" }
}

variable "alb_target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "counter-service-tg"
}

variable "alb_target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "alb_target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "alb_target_type" {
  description = "Target type for the target group (instance, ip, lambda)"
  type        = string
  default     = "ip"
}

variable "alb_health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "alb_health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "HTTP"
}

variable "alb_health_check_matcher" {
  description = "Health check matcher"
  type        = string
  default     = "200-399"
}

variable "alb_health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "alb_health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "alb_health_check_healthy_threshold" {
  description = "Number of successful health checks before considering healthy"
  type        = number
  default     = 2
}

variable "alb_health_check_unhealthy_threshold" {
  description = "Number of failed health checks before considering unhealthy"
  type        = number
  default     = 2
}

variable "alb_listener_port" {
  description = "Listener port"
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTP"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository for the application image"
  type        = string
  default     = "counter-service"
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
  default     = 5
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}
