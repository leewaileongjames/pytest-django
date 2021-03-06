# Defines the Version for Terraform CLI 
# and its Providers                     

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.1"
  backend "s3" {
    bucket = "jameslee-terraform-backend"
    key = "jenkins-pipeline/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-locking"
  }

}

# Declares the AWS Provider and 
# specify the target AWS Region 

provider "aws" {
  region  = var.region
}

# Defines a Security Groups that 
# allows SSH and Web Traffic            

resource "aws_security_group" "SSH-WEB-SG" {
    name = "SSH-WEB-SG"
    description = "SSH Security Group"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Allow Port 22"
      from_port = 22
      protocol = "tcp"
      to_port = 22
    }

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Allow Port 80"
      from_port = 80
      protocol = "tcp"
      to_port = 80
    }

    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Allow all IP and Ports Outbound"
      from_port = 0
      protocol = "-1"
      to_port = 0
    }

    tags = {
      "Name" = "SSH-WEB-SG"
    }
}

# Queries AWS for the AMI ID of the 
# latest AMI for AMZN Linux 2       

data "aws_ami" "amzlinux2" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
        name = "name"
        values = [ "amzn2-ami-kernel-*-gp2" ]
    }

    filter {
        name = "root-device-type"
        values = [ "ebs" ]
    }

    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }

    filter {
        name = "architecture"
        values = [ "x86_64" ]
    }
}

# Defines EC2 Instances 

resource "aws_instance" "EC2-Instance" {
    ami = data.aws_ami.amzlinux2.id
    instance_type = var.instance_type
    user_data = <<-EOF
	#! /bin/bash
	sudo yum update -y && sudo yum install -y docker
	sudo systemctl start docker
	sudo usermod -aG docker ec2-user
	EOF
    key_name = var.instance_keypair
    vpc_security_group_ids = [ 
        aws_security_group.SSH-WEB-SG.id,
    ]
    tags = {
      "Name" = "EC2 from CICD"
    }
}

