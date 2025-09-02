resource "aws_iam_role" "redshift_role" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3_access" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_redshift_cluster" "main" {
  cluster_identifier        = var.cluster_name
  database_name             = var.database_name
  master_username           = var.master_username
  master_password           = var.master_password
  node_type                 = var.node_type
  number_of_nodes           = var.number_of_nodes
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids    = [var.security_group_id]
  publicly_accessible       = var.publicly_accessible
  iam_roles                 = [aws_iam_role.redshift_role.arn]
  skip_final_snapshot       = true

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = var.subnet_ids
}