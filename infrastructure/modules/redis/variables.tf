variable "private_subnet_ids" {
  description = "List of private subnet IDs for Redis"
  type        = list(string)
}
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

