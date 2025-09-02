output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.redshift_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.redshift_vpc.cidr_block
}

output "subnet_ids" {
  description = "List of subnet IDs created for Redshift"
  value       = aws_subnet.redshift_subnets[*].id
}

output "redshift_subnet_group_id" {
  description = "ID of the Redshift subnet group"
  value       = aws_redshift_subnet_group.redshift_subnet_group.id
}

output "redshift_subnet_group_name" {
  description = "Name of the Redshift subnet group"
  value       = aws_redshift_subnet_group.redshift_subnet_group.name
}

output "redshift_security_group_id" {
  description = "ID of the security group for Redshift"
  value       = aws_security_group.redshift_sg.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "route_table_id" {
  description = "ID of the route table"
  value       = aws_route_table.redshift_rt.id
}