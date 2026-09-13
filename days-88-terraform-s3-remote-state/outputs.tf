output "application_bucket" {
  value = aws_s3_bucket.application.bucket
}

output "state_bucket" {
  value = "s3://${var.bucket_name}"
}

output "state_key" {
  value = "day-88/terraform.tfstate"
}
