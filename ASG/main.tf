resource "aws_security_group" "ec2-sg" {
  name        = "project-team1"
  description = "Allow SSH , HTTP and HTTPS inbound  from Frontend app"
  vpc_id      = aws_vpc.main.id
}
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = var.tags
  

resource "aws_launch_template" "server" {
  name                   = "project-asg"
  image_id               = "ami-01f570b45fc279a29"
  instance_type          = "t2.micro"
  user_data              = base64encode(file("user_data.sh"))
  vpc_security_group_ids =  [
     aws_security_group.ec2-sg.id
  ]
  lifecycle {
    create_before_destroy = true
  }
}
