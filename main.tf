provider "aws" {
  region = "us-east-1"  # Change as needed
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI for us-east-1; update for your region
  instance_type = "t2.medium"

  tags = {
    Name = "Terraform-EC2-t2-medium"
  }

  # Optional: Add key name if you want SSH access
  # key_name = "your-key-pair"

  # Optional: security group, subnet, etc.
}
