region              = "us-east-2"
identifier          = "dbname"
allocated_storage   = 20
storage_type        = "gp2"
engine              = "mysql"
engine_version      = "5.7"
instance_class      = "db.t2.micro"
name                = "mydb"
username            = "foo"

publicly_accessible = true
subnet_ids = [
    subnet-07fad8c25a4131479
    subnet-0af6968fa31550b33
    subnet-014102644e5868855