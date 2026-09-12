variable "profile" {
  type        = string
  description = "AWS CLI profile"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "Default VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Default subnet ID"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Home IP allowed to SSH"
}
