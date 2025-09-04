# 🛍️ E-Commerce Data Warehouse - Terraform Deployment

This project automates the deployment of a complete AWS data warehouse infrastructure for e-commerce analytics using Terraform with CI/CD automation powered by GitHub Actions.

## 📋 Prerequisites

Before you begin, ensure you have:

- AWS Account with appropriate permissions
- Terraform (v1.0 or higher) installed locally
- AWS CLI configured with credentials
- Git for version control

## 🗄️ Create an S3 Bucket for Terraform State (AWS Console)

### Step 1: Sign In
Go to https://s3.console.aws.amazon.com/s3 and log into your AWS account.

### Step 2: Create Bucket
1. Click **[Create bucket]**
2. Fill out the bucket details:
   - **Bucket name**: `ecommerce-data-warehouse-raw` (must be globally unique)
   - **AWS Region**: Choose the region Terraform will run in (e.g., `ap-south-1`)

### Step 3: Configure Options
Leave the following as default:
- **Object Ownership**: Accept "ACLs disabled (recommended)"
- **Block Public Access**: Leave all boxes checked
- **Bucket Versioning**: Optional (recommended for state tracking)
- **Encryption**: Optional (you can enable SSE-S3 or SSE-KMS for additional security)

### Step 4: Create the Bucket
Click **[Create bucket]** at the bottom.

## 🗃️ Create DynamoDB Table for State Locking

### 1. Open DynamoDB
In the Search bar, type DynamoDB → Click DynamoDB service

### 2. Create Table
1. Click **Create table** → Fill in:
   - **Table name**: `ecommerce-tf`
   - **Partition key**:
     - Name: `LockID`
     - Type: `String`
   - Leave Sort key unchecked (not required for Terraform locking)

### 3. Create Table
Click **Create table** → Wait for status to become Active (takes a few seconds)

## 📁 Project Structure

```
ecommerce-data-warehouse/
├── main.tf                 # Root module configuration
├── variables.tf            # Input variables
├── outputs.tf             # Output values
├── terraform.tfvars       # Environment variables
├── .github/
│   └── workflows/
│       └── deploy.yml     # CI/CD pipeline
└── modules/
    ├── network/           # VPC, subnets, security groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── redshift/          # Redshift cluster and IAM
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── s3/                # S3 bucket configuration
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## ⚙️ Update the terraform.tfvars

Update the below values according to your configuration:

```hcl
aws_region           = "ap-south-1"
cluster_name         = "ecommerce-dw-cluster"
master_username      = "admin"
master_password      = "your-secure-password-here"
database_name        = "ecommerce_db"
node_type            = "ra3.large"
number_of_nodes      = 1
publicly_accessible  = true
vpc_cidr             = "10.0.0.0/16"
s3_bucket_name       = "ecommerce-data-warehouse-processed"
```

## 🔑 Required Secrets in GitHub

In your GitHub repo, go to **Settings** → **Environments** → **prod** and **dev** → **Add Environment secrets** and add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (e.g., `ap-south-1`)
- `REDSHIFT_MASTER_PASSWORD`

## 🔄 Workflow

### Trigger on main branch (manually)
1. Go to **Actions** → **Terraform CI/CD** → **Run workflow**
2. Select the environment (`staging` or `production`)
3. Click `Run workflow` to deploy resources

### Trigger on main branch (on push)
-> on push to the main branch, the workflow starts automatically

## 🚀 Quick Start Deployment

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd ecommerce-data-warehouse
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key, Secret Key, and Region (ap-south-1)
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review Deployment Plan
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply -auto-approve
```

## 🗺️ Architecture Overview

This deployment creates:

- **Amazon Redshift Cluster**: Data warehouse for analytics
- **Amazon S3 Bucket**: Data storage for processed files
- **VPC Networking**: Secure network infrastructure
- **IAM Roles**: Secure access permissions

## 🔧 What Gets Deployed

### 📊 Redshift Cluster
- **Cluster Name**: `ecommerce-dw-cluster`
- **Database**: `ecommerce_db`
- **Node Type**: `ra3.large` (optimized for analytics)
- **Nodes**: 1 (scalable)
- **Access**: Publicly accessible with secure credentials

### 🌐 Networking
- **VPC**: `10.0.0.0/16` with public subnets
- **Security Group**: Open port 5439 for Redshift access
- **Subnets**: Across multiple availability zones

### 📦 S3 Storage
- **Bucket**: `ecommerce-data-warehouse-processed`
- **Versioning**: Enabled
- **Encryption**: AES-256 server-side encryption

### 🔐 IAM Security
- Dedicated IAM role for Redshift
- S3 read-only access permissions
- Secure assume role policies

## 🎯 Usage Instructions

### Connecting to Redshift
```bash
# Using psql
psql -h your-redshift-endpoint -p 5439 -U admin -d ecommerce_db

# Using AWS CLI
aws redshift get-cluster-credentials --cluster-identifier ecommerce-dw-cluster --db-user admin
```

### Loading Data from S3
```sql
-- Example COPY command
COPY sales_data 
FROM 's3://ecommerce-data-warehouse-processed/sales/' 
IAM_ROLE 'arn:aws:iam::123456789012:role/redshift-role'
FORMAT AS PARQUET;
```

## 💰 Cost Estimation

**Monthly Estimated Costs:**

- **Redshift Cluster**: ~$250-500 (depending on usage)
- **S3 Storage**: ~$0.023 per GB
- **DynamoDB (State Locking)**: < $1
- **Data Transfer**: Variable based on usage

Use `terraform plan` to get accurate cost estimates before deploying.

## 🧹 Cleanup

### Destroy All Resources
```bash
terraform destroy -auto-approve
```

### Manual Cleanup (if needed)
```bash
# Delete Redshift cluster
aws redshift delete-cluster --cluster-identifier ecommerce-dw-cluster --skip-final-snapshot

# Empty and delete S3 bucket
aws s3 rm s3://ecommerce-data-warehouse-processed --recursive
aws s3api delete-bucket --bucket ecommerce-data-warehouse-processed

# Initialize with backend config for destroy
terraform init \
  -backend-config="bucket=ecommerce-data-warehouse-raw" \
  -backend-config="key=terraform.tfstate" \
  -backend-config="region=ap-south-1" \
  -backend-config="dynamodb_table=ecommerce-tf" \
  -backend-config="encrypt=true"
```

## 🚨 Troubleshooting

### Common Issues

**"Bucket already exists"**
- Use a unique S3 bucket name in `terraform.tfvars`

**"Subnet group already exists"**
- Run `terraform destroy` and redeploy with unique names

**Authentication errors**
- Verify AWS credentials and permissions

**Redshift connection issues**
- Check security group rules and network ACLs