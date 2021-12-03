resource "aws_elasticache_subnet_group" "default" {
  name       = "cache-subnet"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

# resource "aws_elasticache_replication_group" "example" {
#   automatic_failover_enabled    = true
#   availability_zones            = ["us-east-1a", "us-east-1b"]
#   replication_group_id          = "tf-rep-group-1"
#   replication_group_description = "test description"
#   node_type                     = "cache.m4.large"
#   number_cache_clusters         = 2
#   parameter_group_name          = "default.redis3.2"
#   port                          = 6379

# }

resource "aws_elasticache_replication_group" "baz" {
  replication_group_id          = "tf-redis-cluster"
  replication_group_description = "test description"
  node_type                     = "cache.t2.small"
  port                          = 6379
#   parameter_group_name          = "default.redis3.2.cluster.on"
  automatic_failover_enabled    = true
  subnet_group_name             = aws_elasticache_subnet_group.default.name


  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 2
  }
}