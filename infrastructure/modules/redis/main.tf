
resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group-${var.environment}"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "checkpoint-redis-${var.environment}"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name

  security_group_ids       = [aws_security_group.redis_sg.id]
  snapshot_retention_limit = 5
  snapshot_window          = "03:00-05:00"

  tags = {
    Name        = "Checkpoint Redis"
    Environment = var.environment
  }
}

resource "aws_security_group" "redis_sg" {
  name_prefix = "checkpoint-redis-"
  description = "Security group for Checkpoint Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.eks_security_group_id]
    cidr_blocks     = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Checkpoint Redis SG"
    Environment = var.environment
  }
}
