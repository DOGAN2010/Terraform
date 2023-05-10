terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  dynamic "ingress" {
    for_each = var.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = var.instance-ami
  instance_type = var.instance-type
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  tags = {
      Name = "Sonar-engine"
  }
  user_data = file("sonar-setup.sh")
 }
output "myinstance-public-ip" {
  value = aws_instance.tf-ec2.public_ip
}
