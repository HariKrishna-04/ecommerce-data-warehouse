resource "aws_vpc" "redshift_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.redshift_vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_subnet" "redshift_subnets" {
  count             = 2
  vpc_id            = aws_vpc.redshift_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone = "${var.aws_region}${count.index % 2 == 0 ? "a" : "b"}"
  tags = {
    Name = "${var.cluster_name}-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "redshift_rt" {
  vpc_id = aws_vpc.redshift_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

resource "aws_route_table_association" "subnet_associations" {
  count          = 2
  subnet_id      = aws_subnet.redshift_subnets[count.index].id
  route_table_id = aws_route_table.redshift_rt.id
}

resource "aws_security_group" "redshift_sg" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for Redshift cluster"
  vpc_id      = aws_vpc.redshift_vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Redshift access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = aws_subnet.redshift_subnets[*].id
  tags = {
    Name = "${var.cluster_name}-subnet-group"
  }
}