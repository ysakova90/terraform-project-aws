packer {
	required_plugins {
		amazon = {
			version = ">= 0.0.1"
			source = "github.com/hashicorp/amazon"
		}
	}
}



source "amazon-ebs" "image" {
	ami_name             = "golden-image {{timestamp}}"
	ssh_private_key_file = "/home/cloudshell-user/.ssh/id_rsa"
	ssh_keypair_name     = "packer"
	instance_type        = "t2.micro"
	ssh_username         = "ec2-user"
	region               = "us-east-1"
    ami_regions          = [
        "us-east-2",
        "us-west-2",
    ]
	source_ami = "ami-090fa75af13c156b4"
	run_tags = {
		Name = "Packer instance for golden-image"
	}
}



build {
	sources = [
		"source.amazon-ebs.image"
	]
    provisioner "shell" {
		inline = [
			"echo Installing Telnet",
            #"sudo yum update -y",
			"sudo yum install telnet -y",   #Change for ubuntu
            "sudo useradd ansible",
            "sudo yum install httpd -y"


            #!/bin/bash 
             Work with Amazon AMI on this
             "sudo yum install httpd -y",
             "sudo yum install php php-mysql -y",
             "sudo systemctl restart httpd",
             "sudo systemctl enable httpd",
             "sudo yum install wget -y",
             "sudo wget https://wordpress.org/wordpress-4.0.32.tar.gz",
             "sudo tar -xf wordpress-4.0.32.tar.gz -C /var/www/html/",
             "sudo mv /var/www/html/wordpress/* /var/www/html/",
             "sudo chown -R apache:apache /var/www/html/",
             "sudo systemctl restart httpd"

            ## script for backup solution

            ## penetration tool 

            ## monitoring tool
	    ]
    }
}