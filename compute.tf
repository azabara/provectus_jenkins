
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [
      "ami-0976b07424f8f4ceb",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "jenkins-instance" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.medium"
  key_name        = tf-jenkins-aws
  vpc_id          = vpc-0b219a61
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh_jenkins.id]
  subnet_id          = subnet-b4c31ac8
  #name            = "${var.name}"
  

  associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance"
  }
}

resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = vpc-0b219a61

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
