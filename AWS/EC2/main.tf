#Resource to create a SSH private key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Resource to Create Key Pair
# resource "aws_key_pair" "web" {
#   key_name   = "ec2keypair"
#   # key_name   = var.key_pair_name
#   public_key = tls_private_key.ec2_key.public_key_openssh
# }

# # # #Resource to Create Key Pair
# resource "aws_key_pair" "aws_keypair" {
#   key_name   = "ec2keypair"
#   public_key = file( var.local_file.local_key_pair.filename )
# }

resource "local_file" "local_key_pair" {
  filename        = "ec2keypair.pem"
  file_permission = "0400"
  content         = tls_private_key.ec2_key.private_key_pem
}

resource "aws_instance" "server" {
  count = var.number

  ami           = var.image
  instance_type = var.instance-type
  ## Use tags to easily identify your EC2 instance
  tags = {
    Name        = "${var.servername}-0${count.index}"
    Description = "An Nginx server on Ubuntu"
    Server = "Nginx"
  }
  ## Below will run a bash script on the EC2 once it is installed
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudp apt install nginx -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  ## Below is used to use the existing keypair to access EC2 instance
  key_name               = aws_key_pair.web.id
  vpc_security_group_ids = [aws_security_group.ssh-access.id]
}


# # # #Resource to Create Key Pair
# resource "aws_key_pair" "aws_keypair" {
#   key_name   = "ec2keypair"
#   public_key = file("local_file.local_key_pair.filename")
# }

resource "aws_key_pair" "web" {
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow ssh access from internet"
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# default user is ubuntu

output "publicips" {
  value = aws_instance.server[*].public_ip
}