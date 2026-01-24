provider "aws" {
  region = "us-east-2"
}

# Fetch Default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "devops_sg" {
  name = "devops_sg"
   vpc_id = "vpc-02d48e12666c9a429"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["42.104.220.144/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTPS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "devops_vm" {
  ami = "ami-09040d770ffe2224f"
  instance_type = "t2.micro"
  key_name      = "devops-key"
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "devops-assessment"
  }
}