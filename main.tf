provider "aws" {
  region  = "eu-central-1"
}

resource "aws_instance" "jenkins-instance" {
  ami             = "ami-0976b07424f8f4ceb"
  instance_type   = "t2.medium"
  vpc_name        = "provectus"
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh_jenkins.id]
  subnet_name      = "provectus-public-eu-central-1a"
    associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance"
  }
}

resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = "vpc-06d4ab0a55916ebff"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "jenkins_ip_address" {
  value = aws_instance.jenkins-instance.public_dns
}
