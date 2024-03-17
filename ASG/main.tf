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
