data "terraform_remote_state" "backend" {
  backend = "s3"
   config  = {
    bucket = "team1-aws-storage"
    key = "vpc-statefile"
    region = "us-east-1"
  }
}

#========= EC2 SG ===========

 resource "aws_security_group" "ec2-sg" {
  name        = "project-team"
  description = "EC2 Instance Security Group"
  vpc_id      =   data.terraform_remote_state.backend.outputs.vpc_id


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
    ipv6_cidr_blocks = ["::/0"]
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
  name = "project-asg"
  min_size                  = 1
  max_size                  = 99
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [
    data.terraform_remote_state.backend.outputs.private_subnet1,
      data.terraform_remote_state.backend.outputs.private_subnet2,
      data.terraform_remote_state.backend.outputs.private_subnet3
  ]
  depends_on = [module.alb]
  # Launch template
  launch_template_name        = "project-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true
  user_data                   =  filebase64("${path.module}/user_data.sh")
  image_id        = data.aws_ami.amazon.id
  instance_type     = "t3.micro"
  ebs_optimized     = false
  enable_monitoring = false
  target_group_arns = module.alb.target_group_arns
  security_groups = [
    aws_security_group.ec2-sg.id
  ]
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name   = "my-alb"

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.backend.outputs.vpc_id
  subnets         = [
     data.terraform_remote_state.backend.outputs.public_subnet1,
     data.terraform_remote_state.backend.outputs.public_subnet2,
     data.terraform_remote_state.backend.outputs.public_subnet3
  ]
  security_groups = [aws_security_group.alb-sg.id]


  target_groups = [
    {
      name_prefix      = "app-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = var.tags
}
# ALB Security Group
resource "aws_security_group" "alb-sg" {
  description = "ALB Security Group"
  vpc_id      = data.terraform_remote_state.backend.outputs.vpc_id


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


resource "aws_route53_record" "wordpress" {
  zone_id = var.zone_id
  name    = "wordpress.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.alb.lb_dns_name]
}


0