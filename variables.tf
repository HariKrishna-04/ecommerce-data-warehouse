variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Redshift cluster name"
  type        = string
  default     = "ecommerce-dw-cluster"
}

variable "master_username" {
  description = "Redshift master username"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password for Redshift"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Redshift database name"
  type        = string
  default     = "ecommerce_db"
}

variable "node_type" {
  description = "Redshift node type"
  type        = string
  default     = "dc2.large"
}

variable "number_of_nodes" {
  description = "Number of Redshift nodes"
  type        = number
  default     = 1
}

variable "publicly_accessible" {
  description = "Whether Redshift is publicly accessible"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for data storage"
  type        = string
  default     = "ecommerce-data-warehouse-123456789012"
}