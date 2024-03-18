terraform {
  backend "s3" {
    bucket = "team1-aws-storage"
    key    = "vpc-statefile"
    region = "us-east-1"
  }
}
