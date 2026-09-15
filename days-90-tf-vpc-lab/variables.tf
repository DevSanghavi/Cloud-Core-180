variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.90.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to use"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.90.1.0/24", "10.90.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.90.10.0/24", "10.90.11.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateway for private subnets"
  default     = true
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources"
  default = {
    Project   = "Cloud-Core-180"
    Day       = "90"
    Topic     = "Terraform-VPC-Lab"
    ManagedBy = "terraform"
  }
}
