variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for Redis cluster"
  type        = string
}

variable "eks_security_group_id" {
  description = "EKS cluster security group ID"
  type        = string
}
