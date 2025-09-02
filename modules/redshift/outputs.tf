output "redshift_cluster_id" {
  description = "Redshift cluster ID"
  value       = aws_redshift_cluster.main.id
}

output "redshift_cluster_arn" {
  description = "Redshift cluster ARN"
  value       = aws_redshift_cluster.main.arn
}

output "redshift_endpoint" {
  description = "Redshift cluster endpoint"
  value       = aws_redshift_cluster.main.endpoint
}

output "redshift_database_name" {
  description = "Redshift database name"
  value       = aws_redshift_cluster.main.database_name
}

output "redshift_master_username" {
  description = "Redshift master username"
  value       = aws_redshift_cluster.main.master_username
}

output "redshift_node_type" {
  description = "Redshift node type"
  value       = aws_redshift_cluster.main.node_type
}

output "redshift_cluster_type" {
  description = "Redshift cluster type"
  value       = aws_redshift_cluster.main.cluster_type
}

output "redshift_iam_role_arn" {
  description = "IAM role ARN associated with Redshift"
  value       = aws_iam_role.redshift_role.arn
}

output "redshift_publicly_accessible" {
  description = "Whether Redshift is publicly accessible"
  value       = aws_redshift_cluster.main.publicly_accessible
}

output "redshift_availability_zone" {
  description = "Redshift availability zone"
  value       = aws_redshift_cluster.main.availability_zone
}