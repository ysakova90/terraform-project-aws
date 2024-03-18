terraform {
  backend "s3" {
    bucket = "team1-aws-storage"
    key    = "rds_statefile"
    region = "us-east-1"
  }
}
