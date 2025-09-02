variable "cluster_name" {
  description = "Name of the Redshift cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for Redshift"
  type        = string
}

variable "master_password" {
  description = "Master password for Redshift"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the default database"
  type        = string
}

variable "node_type" {
  description = "Redshift node type"
  type        = string
  default     = "dc2.large"
}

variable "number_of_nodes" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID where Redshift will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Redshift"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for Redshift"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the cluster is publicly accessible"
  type        = bool
  default     = false
}

variable "iam_role_arn" {
  description = "IAM role ARN for Redshift"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket name for data storage"
  type        = string
}