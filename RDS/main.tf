data "terraform_remote_state" "backend" {
  backend = "s3"
   config  = {
    bucket = "team1-aws-storage"
    key = "vpc-statefile"
    region = "us-east-1"
  }
}



resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = [ 
    data.terraform_remote_state.backend.outputs.private_subnet1,
    data.terraform_remote_state.backend.outputs.private_subnet2,
    data.terraform_remote_state.backend.outputs.private_subnet3
  ]

}

resource "aws_security_group" "RDS_allow_rule" {
  description = "Allow port 3306"
  vpc_id      = data.terraform_remote_state.backend.outputs.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_rds_cluster" "wordpress_db_cluster" {
  cluster_identifier   = "wordpress-cluster"
  engine               = var.engine
  engine_version       = var.engine_version
  database_name   = var.database_name
  master_username = var.master_username
  #master_password = random_string.rds_password.result
  master_password        = var.master_password

  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.RDS_subnet_grp.name
  vpc_security_group_ids  = ["${aws_security_group.RDS_allow_rule.id}"]
  backup_retention_period = 5
  storage_encrypted       = true
}
resource "aws_rds_cluster_instance" "wordpress_cluster_instance_writer" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.wordpress_db_cluster.id
  identifier         = "wordpress-cluster-instance-writer"
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.wordpress_db_cluster.engine
  engine_version     = aws_rds_cluster.wordpress_db_cluster.engine_version

  depends_on = [aws_rds_cluster.wordpress_db_cluster]
}
resource "aws_rds_cluster_instance" "wordpress_cluster_instance_readers" {
  count              = var.number_of_instances 
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.wordpress_db_cluster.id
  identifier         = "wordpress-cluster-instance-reader${format(count.index + 1)}"
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.wordpress_db_cluster.engine
  engine_version     = aws_rds_cluster.wordpress_db_cluster.engine_version

  depends_on = [aws_rds_cluster_instance.wordpress_cluster_instance_writer]
}
resource "aws_route53_record" "wordpress" {
  zone_id = var.zone_id
  name    = "wordpress.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records        = ["aws_alb.application-lb.dns_name"]
}
resource "aws_route53_record" "writer_endpoit" {
  zone_id = var.zone_id
  name    = "writer.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.wordpress_cluster_instance_writer.endpoint]
}
resource "aws_route53_record" "readers_endpoint" {
  count = var.number_of_instances
  zone_id = var.zone_id
  name    = "reader${count.index + 1}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.wordpress_cluster_instance_readers[count.index].endpoint]
}
