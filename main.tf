terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# Network
resource "aws_vpc" "aws-three-tier-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "aws-three-tier-vpc"
  }
}

resource "aws_subnet" "aws-three-tier-pub-sub-1" {
  vpc_id                  = aws_vpc.aws-three-tier-vpc.id
  cidr_block              = "10.0.0.0/28"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-three-tier-pub-sub-1"
  }
}

resource "aws_subnet" "aws-three-tier-pub-sub-2" {
  vpc_id                  = aws_vpc.aws-three-tier-vpc.id
  cidr_block              = "10.0.0.16/28"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-three-tier-pub-sub-2"
  }
}

resource "aws_subnet" "aws-three-tier-pvt-sub-1" {
  vpc_id                  = aws_vpc.aws-three-tier-vpc.id
  cidr_block              = "10.0.0.32/28"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-three-tier-pvt-sub-1"
  }
}

resource "aws_subnet" "aws-three-tier-pvt-sub-2" {
  vpc_id                  = aws_vpc.aws-three-tier-vpc.id
  cidr_block              = "10.0.0.48/28"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-three-tier-pvt-sub-2"
  }
}

resource "aws_subnet" "aws-three-tier-pvt-sub-3" {
  vpc_id                  = aws_vpc.aws-three-tier-vpc.id
  cidr_block              = "10.0.0.64/28"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-three-tier-pvt-sub-3"
  }
}

resource "aws_subnet" "aws-three-tier-pvt-sub-4" {
  vpc_id                  = aws_vpc.aws-three-tier-vpc.id
  cidr_block              = "10.0.0.80/28"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-three-tier-pvt-sub-4"
  }
}

resource "aws_internet_gateway" "aws-three-tier-igw" {
  vpc_id = aws_vpc.aws-three-tier-vpc.id

  tags = {
    Name = "aws-three-tier-igw"
  }
}

resource "aws_route_table" "aws-three-tier-web-rt" {
  vpc_id = aws_vpc.aws-three-tier-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-three-tier-igw.id
  }

  tags = {
    Name = "aws-three-tier-web-rt"
  }
}

resource "aws_route_table" "aws-three-tier-app-rt" {
  vpc_id = aws_vpc.aws-three-tier-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.aws-three-tier-natgw-01.id
  }

  tags = {
    Name = "aws-three-tier-app-rt"
  }
}

resource "aws_route_table_association" "aws-three-tier-rt-as-1" {
  subnet_id      = aws_subnet.aws-three-tier-pub-sub-1.id
  route_table_id = aws_route_table.aws-three-tier-web-rt.id
}

resource "aws_route_table_association" "aws-three-tier-rt-as-2" {
  subnet_id      = aws_subnet.aws-three-tier-pub-sub-2.id
  route_table_id = aws_route_table.aws-three-tier-web-rt.id
}

resource "aws_route_table_association" "aws-three-tier-rt-as-3" {
  subnet_id      = aws_subnet.aws-three-tier-pvt-sub-1.id
  route_table_id = aws_route_table.aws-three-tier-app-rt.id
}

resource "aws_route_table_association" "aws-three-tier-rt-as-4" {
  subnet_id      = aws_subnet.aws-three-tier-pvt-sub-2.id
  route_table_id = aws_route_table.aws-three-tier-app-rt.id
}

resource "aws_route_table_association" "aws-three-tier-rt-as-5" {
  subnet_id      = aws_subnet.aws-three-tier-pvt-sub-3.id
  route_table_id = aws_route_table.aws-three-tier-app-rt.id
}

resource "aws_route_table_association" "aws-three-tier-rt-as-6" {
  subnet_id      = aws_subnet.aws-three-tier-pvt-sub-4.id
  route_table_id = aws_route_table.aws-three-tier-app-rt.id
}

resource "aws_eip" "aws-three-tier-nat-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "aws-three-tier-natgw-01" {
  allocation_id = aws_eip.aws-three-tier-nat-eip.id
  subnet_id     = aws_subnet.aws-three-tier-pub-sub-1.id

  tags = {
    Name = "aws-three-tier-natgw-01"
  }
  depends_on = [aws_internet_gateway.aws-three-tier-igw]
}

resource "aws_lb" "aws-three-tier-app-lb" {
  name               = "aws-three-tier-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws-three-tier-alb-app-sg.id]
  subnets            = [aws_subnet.aws-three-tier-pub-sub-1.id, aws_subnet.aws-three-tier-pub-sub-2.id]

  tags = {
    Environment = "aws-three-tier-app-lb"
  }
}

resource "aws_lb_target_group" "aws-three-tier-app-lb-tg" {
  name     = "aws-three-tier-app-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aws-three-tier-vpc.id
}

resource "aws_lb_listener" "aws-three-tier-app-lb-listener" {
  load_balancer_arn = aws_lb.aws-three-tier-app-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws-three-tier-app-lb-tg.arn
  }
}

resource "aws_autoscaling_attachment" "aws-three-tier-app-asattach" {
  autoscaling_group_name = aws_autoscaling_group.aws-three-tier-app-asg.id
  lb_target_group_arn    = aws_lb_target_group.aws-three-tier-app-lb-tg.arn
}

# Database
resource "aws_db_subnet_group" "aws-three-tier-db-sub-grp" {
  name       = "aws-three-tier-db-sub-grp"
  subnet_ids = [aws_subnet.aws-three-tier-pvt-sub-3.id, aws_subnet.aws-three-tier-pvt-sub-4.id]
}

resource "aws_db_instance" "aws-three-tier-db" {
  allocated_storage       = 20
  backup_retention_period = 7
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.35"
  instance_class          = "db.t3.micro"
  identifier              = "aws-three-tier-db"
  username                = "admin"
  password                = var.db_password
  parameter_group_name    = "default.mysql8.0"
  db_subnet_group_name    = aws_db_subnet_group.aws-three-tier-db-sub-grp.name
  vpc_security_group_ids  = [aws_security_group.aws-three-tier-db-sg.id]
  multi_az                = false
  skip_final_snapshot     = true
  publicly_accessible     = false
}

# Scaling
resource "aws_launch_template" "aws-three-tier-app-lt" {
  name_prefix   = "aws-three-tier-app-lt"
  image_id      = "ami-0bfd23bc25c60d5a1"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.aws-three-tier-ec2-asg-sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Healtheir App"
    }
  }

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "aws-three-tier-app-asg" {
  name                = "aws-three-tier-app-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.aws-three-tier-pvt-sub-1.id, aws_subnet.aws-three-tier-pvt-sub-2.id]

  launch_template {
    id      = aws_launch_template.aws-three-tier-app-lt.id
    version = "$Latest"
  }
}

# Security 
resource "aws_security_group" "aws-three-tier-alb-app-sg" {
  name        = "aws-three-tier-alb-app-sg"
  description = "load balancer security group for app tier"
  vpc_id      = aws_vpc.aws-three-tier-vpc.id
  depends_on  = [aws_vpc.aws-three-tier-vpc]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-three-tier-alb-app-sg"
  }
}

resource "aws_security_group" "aws-three-tier-ec2-asg-sg" {
  name        = "aws-three-tier-ec2-asg-sg"
  description = "Allow HTTP, SSH traffic"
  vpc_id      = aws_vpc.aws-three-tier-vpc.id
  depends_on  = [aws_vpc.aws-three-tier-vpc]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
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

  tags = {
    Name = "aws-three-tier-ec2-asg-sg-app"
  }
}

resource "aws_security_group" "aws-three-tier-db-sg" {
  name        = "aws-three-tier-db-sg"
  description = "Allow traffic from app tier"
  vpc_id      = aws_vpc.aws-three-tier-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.aws-three-tier-ec2-asg-sg.id]
    cidr_blocks     = ["10.0.0.32/28", "10.0.0.48/28"]
    description     = "Access for the app ALB SG"
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.aws-three-tier-ec2-asg-sg.id]
    cidr_blocks     = ["10.0.0.32/28", "10.0.0.48/28"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}