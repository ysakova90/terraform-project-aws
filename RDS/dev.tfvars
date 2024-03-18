region ="us-east-1"

engine              = "aurora-mysql"
engine_version      = "5.7.mysql_aurora.2.10.2"
instance_class      = "db.t2.micro"
database_name       = "wordpress_db"
master_username     = "dbuser"
number_of_instances = 1
tags = {

  Name      = "Terraform-project"
  createdBy = "Team-1"
}