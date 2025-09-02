# outputs.tf
output "redshift_endpoint" {
  description = "Redshift cluster endpoint"
  value       = module.redshift.redshift_endpoint
}

output "redshift_database_name" {
  description = "Redshift database name"
  value       = module.redshift.redshift_database_name
}

output "redshift_master_username" {
  description = "Redshift master username"
  value       = module.redshift.redshift_master_username
}

output "s3_bucket_name" {
  description = "S3 bucket name for data storage"
  value       = module.s3.bucket_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}