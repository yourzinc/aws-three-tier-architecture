output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.aws-three-tier-vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.aws-three-tier-pub-sub-1.id, aws_subnet.aws-three-tier-pub-sub-2.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.aws-three-tier-pvt-sub-1.id, aws_subnet.aws-three-tier-pvt-sub-2.id, aws_subnet.aws-three-tier-pvt-sub-3.id, aws_subnet.aws-three-tier-pvt-sub-4.id]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.aws-three-tier-igw.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.aws-three-tier-natgw-01.id
}

output "application_load_balancer_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.aws-three-tier-app-lb.arn
}

output "database_instance_endpoint" {
  description = "The endpoint of the RDS database instance"
  value       = aws_db_instance.aws-three-tier-db.endpoint
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.aws-three-tier-app-asg.name
}

output "security_group_ids" {
  description = "The IDs of the Security Groups"
  value       = [aws_security_group.aws-three-tier-alb-app-sg.id, aws_security_group.aws-three-tier-ec2-asg-sg.id, aws_security_group.aws-three-tier-db-sg.id]
}
