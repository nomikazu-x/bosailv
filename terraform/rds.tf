####################################################
# RDS SSM
####################################################

data "aws_ssm_parameter" "database_name" {
  name = "${local.ssm_parameter_store_base}/database_name"
}

data "aws_ssm_parameter" "database_user" {
  name = "${local.ssm_parameter_store_base}/database_user"
}

data "aws_ssm_parameter" "database_password" {
  name = "${local.ssm_parameter_store_base}/database_password"
}

####################################################
# RDS SG
####################################################

resource "aws_security_group" "database_sg" {
  name        = "${local.app_name}-database-sg"
  description = "${local.app_name}-database"

  vpc_id = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.app_name}-database-sg"
  }
}

resource "aws_security_group_rule" "database_sg_rule" {
  security_group_id = aws_security_group.database_sg.id

  type = "ingress"

  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  source_security_group_id = aws_security_group.app.id
}

resource "aws_db_subnet_group" "database_sg_group" {
  name        = "${local.app_name}-database-subnet-group"
  description = "${local.app_name}-database-subnet-group"
  subnet_ids  = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id,
    aws_subnet.private_1d.id,
  ]
}

####################################################
# RDS Cluster
####################################################

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${local.app_name}-database-cluster"

  db_subnet_group_name   = aws_db_subnet_group.database_sg_group.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]

  engine = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.01.0"
  port   = "3306"

  database_name   = data.aws_ssm_parameter.database_name.value
  master_username = data.aws_ssm_parameter.database_user.value
  master_password = data.aws_ssm_parameter.database_password.value

  skip_final_snapshot = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
}

####################################################
# RDS Cluster Instance
####################################################

resource "aws_rds_cluster_instance" "this" {
  identifier         = "${local.app_name}-database-cluster-instance"
  cluster_identifier = aws_rds_cluster.this.id

  engine = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  instance_class = "db.t4g.medium"
  db_subnet_group_name = aws_rds_cluster.this.db_subnet_group_name
}

####################################################
# RDS cluster config
####################################################

resource "aws_rds_cluster_parameter_group" "this" {
  name   = "${local.app_name}-database-cluster-parameter-group"
  family = "aurora-mysql8.0"

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}

####################################################
# Create SSM DB url
####################################################

resource "aws_ssm_parameter" "database_url" {
  name  = "${local.ssm_parameter_store_base}/database_url"
  type  = "String"
  value = aws_rds_cluster.this.endpoint
}
