environment          = "dev"
vpc_cidr             = "10.90.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.90.1.0/24", "10.90.2.0/24"]
private_subnet_cidrs = ["10.90.10.0/24", "10.90.11.0/24"]
enable_nat_gateway   = true

common_tags = {
  Project     = "Cloud-Core-180"
  Day         = "90"
  Topic       = "Terraform-VPC-Lab"
  ManagedBy   = "terraform"
  Owner       = "dev-sanghavi"
  CostCenter  = "learning"
  Environment = "dev"
}
