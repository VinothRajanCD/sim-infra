resource "aws_security_group" "bastion_ec2_sg" {
  name        = "sim-${var.env_name}-bastion-sg"
  description = "Allow access to the world"
  vpc_id      = var.vpc_id

  ingress {
    description = "Outline VPN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["3.106.125.227/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "sim-${var.env_name}-bastion-sg"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.bastion_ec2_sg.id]
  key_name                    = var.bastion_ec2_keypair
  subnet_id                   = var.public_subnet_1
  disable_api_termination     = true
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
  tags = {
    "Name"        = "sim-${var.env_name}-bastion-ec2"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
  }
}