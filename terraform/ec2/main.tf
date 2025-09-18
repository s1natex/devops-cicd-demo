data "aws_caller_identity" "me" {}
data "aws_region" "current" {}

# Latest Amazon Linux 2023 x86_64
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Default VPC + first subnet (simple demo)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ec2-sg"
  description = "Allow SSH, API 8000, Web 8080"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = null

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size_gb
    encrypted   = var.encrypt_ebs
    kms_key_id  = var.kms_key_id
  }

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${var.project}-ec2"
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = aws_instance.ec2.availability_zone
  size              = var.volume_size_gb
  type              = "gp3"
  encrypted         = var.encrypt_ebs
  kms_key_id        = var.kms_key_id

  tags = { Name = "${var.project}-data" }
}

resource "aws_volume_attachment" "data_att" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.ec2.id
}

output "public_ip" { value = aws_instance.ec2.public_ip }
output "public_dns" { value = aws_instance.ec2.public_dns }
output "ssh_example" { value = "ssh -i <your.pem> ec2-user@${aws_instance.ec2.public_ip}" }
output "web_url" { value = "http://${aws_instance.ec2.public_ip}:8080" }
output "api_url" { value = "http://${aws_instance.ec2.public_ip}:8000/tasks" }
