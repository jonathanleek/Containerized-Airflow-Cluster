#----------------------------------
#Create security group for rds instance
#----------------------------------
resource "aws_security_group" "db-sg" {
  name        = "${var.cluster_name}-db-sg"
#  count       = 1
  description = "Security group for airflow rds instance"
  vpc_id      = aws_vpc.airflow_vpc.id
  tags        = var.tags

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "postgresql-tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------
#Create rds subnet group
#----------------------------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = [aws_subnet.airflow_subnet_a.id, aws_subnet.airflow_subnet_b.id]
  tags       = var.tags
}


#----------------------------------
#Create serverless AWS Cluster
#----------------------------------
resource "aws_rds_cluster" "airflow_database" {
  cluster_identifier = "${var.cluster_name}-db"
  copy_tags_to_snapshot = true
  engine = "aurora-postgresql"
  engine_mode = "serverless"
  availability_zones = var.aws_availability_zones
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
}