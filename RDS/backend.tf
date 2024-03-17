terraform {
  backend "s3" {
    bucket = "team1-aws-storage"
    key    = "path/to/my/tfstate"
    region = "us-east-1"
  }
}
