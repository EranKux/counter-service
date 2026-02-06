output "redis_endpoint" {
  value       = module.redis.redis_endpoint
  description = "Redis cluster endpoint for counter service"
}

output "redis_port" {
  value       = module.redis.redis_port
  description = "Redis port"
}

output "redis_security_group_id" {
  value       = module.redis.redis_security_group_id
  description = "Redis security group ID"
}

output "alb_controller_role_arn" {
  value       = module.alb_controller_irsa.role_arn
  description = "IAM role ARN for AWS Load Balancer Controller"
}
