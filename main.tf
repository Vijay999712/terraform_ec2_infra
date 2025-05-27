provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "minikube_sg" {
  name        = "minikube-sg"
  description = "Allow NodePort and web access"

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For manual SSH if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minikube_ec2" {
  ami                         = "ami-0e58b56aa4d64231b" # Amazon Linux 2023
  instance_type               = "t2.medium"
  key_name                    = "east1"
  security_groups             = [aws_security_group.minikube_sg.name]
  associate_public_ip_address = true
  user_data                   = file("userdata.sh") # Contains Minikube + delegate install

  tags = {
    Name = "MinikubeEC2"
  }
}
