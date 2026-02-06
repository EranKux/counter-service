variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
