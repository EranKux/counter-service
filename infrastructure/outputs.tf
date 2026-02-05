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
