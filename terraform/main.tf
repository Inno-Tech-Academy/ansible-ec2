# Configure AWS Provider
provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

# Create Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for frontend and backend instances"

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Consider restricting this to your specific IP range
  }

  # Allow frontend React port
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow backend Node.js port
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow PostgreSQL port
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
  }
}

# Create Frontend Instance
resource "aws_instance" "frontend" {
  ami           = "ami-0e1bed4f06a3b463d"  # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = "main-kp"

  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "frontend-react"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

# Create Backend Instance
resource "aws_instance" "backend" {
  ami           = "ami-0e1bed4f06a3b463d"  # Ubutnu 22.04
  instance_type = "t2.micro"
  key_name      = "main-kp"

  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "backend-nodejs"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

# Output the public IPs
output "frontend_public_ip" {
  value = aws_instance.frontend.public_dns
}

output "backend_public_ip" {
  value = aws_instance.backend.public_dns
}
