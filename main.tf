terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0e58b56aa4d64231b"  # Amazon Linux 2 AMI in us-east-1
  instance_type = "t2.medium"
  key_name      = "east1"             # Replace with your actual key pair name

  user_data = <<-EOF
    #!/bin/bash
    set -e

    yum update -y
    yum install -y git
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
    chown ec2-user:ec2-user /usr/local/bin/kubectl

    yum install -y conntrack

    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    mv minikube /usr/local/bin/
    chown ec2-user:ec2-user /usr/local/bin/minikube

    grep -qxF 'export PATH=$PATH:/usr/local/bin' /home/ec2-user/.bash_profile || echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bash_profile
  EOF

  tags = {
    Name = "Terraform-EC2-t2-medium"
  }
}
