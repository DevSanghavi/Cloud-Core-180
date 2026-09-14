variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "subnet_configs" {
  type = list(object({
    name   = string
    cidr   = string
    az     = string
    public = bool
  }))
  description = "List of subnet configurations"
}

variable "instance_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default     = {}
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable detailed monitoring on EC2"
  default     = false
}
