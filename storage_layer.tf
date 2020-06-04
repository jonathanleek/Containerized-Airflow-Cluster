#----------------------------------
#Create serverless RDS Cluster
#----------------------------------
resource "aws_rds_cluster" "airflow_database" {
  cluster_identifier = "${var.cluster_name}-db"
  copy_tags_to_snapshot = true
  engine = "aurora-postgresql2.3"
  engine_mode = "serverless"
  availability_zones = aws_subnet.private.availability_zone
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  master_password = var.db_password
  master_username = var.db_username
  backup_retention_period = 3
  port = 5432
  vpc_security_group_ids  = [aws_security_group.db-sg.id]
  publicly_accessible     = false
  apply_immediately       = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  tags = var.tags

  scaling_configuration {
    auto_pause = true
    max_capacity = 256
    min_capacity = 2
    seconds_until_auto_pause = 300
    timeout_action = "RollbackCapacityChange"
  }
}

#----------------------------------
#Create Redis Queue
#----------------------------------
resource "aws_elasticache_cluster" "airflow_queue" {
  cluster_id             = "${var.cluster_name}-queue"
  engine           = "redis"
  node_type = "cache.t3.small"
  num_cache_nodes = 1
  parameter_group_name = aws_elasticache_parameter_group.airflow_redis_pg.name
  subnet_group_name = aws_elasticache_subnet_group.airflow_redis_subnet_group.name
  security_group_ids = [aws_security_group.airflow_elasticache_sg.id]
  availability_zone =  aws_subnet.private.availability_zone
  tags             = var.tags
}

#----------------------------------
#Create EFS for DAG repositories
#----------------------------------
resource "aws_efs_file_system" efs {
}