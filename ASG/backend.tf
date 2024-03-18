terraform {
  backend "s3" {
    bucket = "team1-aws-storage"
    key    = "asg_statefile"
    region = "us-east-1"
  }
}