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
    cidr_blocks = ["0.0.0.0/0"] # SSH access for Terraform
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minikube_ec2" {
  ami                         = "ami-0e58b56aa4d64231b"
  instance_type               = "t2.medium"
  key_name                    = "east1"
  security_groups             = [aws_security_group.minikube_sg.name]
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")

  tags = {
    Name = "MinikubeEC2"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for kubeconfig to be ready...'",
      "sleep 90",
      "echo 'Applying Harness Delegate YAML...'",
      "echo '${file("delegate.yaml")}' > /home/ec2-user/delegate.yaml",
      "export KUBECONFIG=/home/ec2-user/.kube/config",
      "kubectl apply -f /home/ec2-user/delegate.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/east1.pem") # Update path if needed
      host        = self.public_ip
    }
  }
}
