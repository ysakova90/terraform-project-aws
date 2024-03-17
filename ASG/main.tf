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

resource "aws_security_group" "allow_tls" {
  name        = "project-team1"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

 # Allow HTTP/HTTPS from ALL
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP/HTTPS from ALL
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


   

