# terraform.tfvars
aws_region        = "ap-south-1"
cluster_name      = "ecommerce-dw-cluster"
master_username   = "admin"
master_password   = "Hari05B7"
database_name     = "ecommerce_db"
node_type         = "dc2.large"
number_of_nodes   = 1
publicly_accessible = true
vpc_cidr          = "10.0.0.0/16"
s3_bucket_name    = "ecommerce-data-warehouse-raw"