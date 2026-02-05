output "redis_endpoint" {
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
  description = "Redis cluster endpoint"
}

output "redis_port" {
  value       = aws_elasticache_cluster.redis.port
  description = "Redis port"
}

output "redis_security_group_id" {
  value       = aws_security_group.redis_sg.id
  description = "Redis security group ID"
}
