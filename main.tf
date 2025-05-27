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
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI in us-east-1
  instance_type = "t2.medium"
  key_name      = "east1"             # 🔑 Replace with your actual key pair name

  tags = {
    Name = "Terraform-EC2-t2-medium"
  }
}
