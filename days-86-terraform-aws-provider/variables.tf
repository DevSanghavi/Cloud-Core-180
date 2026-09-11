variable "profile" {
  description = "AWS CLI profile used by Terraform"
  type        = string
}

variable "region" {
  description = "AWS deployment region"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}
