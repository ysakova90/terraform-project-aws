data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = "team1-aws-storage"
    key    = "vpc-statefile"
    region = "us-east-1"
  }
}

#=========  SG ===========

resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "EC2 Instance Security Group"
  vpc_id      = data.terraform_remote_state.backend.outputs.vpc_id


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


  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = var.tags
}

# Pulls AMI information
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.5.3"
  # Autoscaling group
  name                      = "project-asg"
  min_size                  = 1
  max_size                  = 99
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.terraform_remote_state.backend.outputs.private_subnets


  # Launch template
  launch_template_name        = "project-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true
  user_data                   = filebase64("${path.module}/user_data.sh")
  image_id                    = data.aws_ami.amazon.id
  instance_type               = "t3.micro"
  ebs_optimized               = false
  enable_monitoring           = false
  security_groups = [
    aws_security_group.my_sg.id
  ]
}
resource "aws_alb" "application-lb" {
  name               = "project-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            =  data.terraform_remote_state.backend.outputs.public_subnets
}

# Target group
resource "aws_alb_target_group" "project-tg" {

  name        = "project-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.backend.outputs.vpc_id


}

# Creating Listener
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.application-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.project-tg.arn
    type             = "forward"
  }
}
 


data "aws_route53_zone" "my_zone" {
  name         = var.domain_name
  private_zone = false
}



resource "aws_route53_record" "alias_route53_record" {
  zone_id = data.aws_route53_zone.my_zone.zone_id
  name    = "wordpress.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_alb.application-lb.dns_name
    zone_id                = aws_alb.application-lb.zone_id
    evaluate_target_health = true
  }
}
