output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "subnet_ids" {
  value       = { for s in aws_subnet.main : s.tags["Name"] => s.id }
  description = "Map of subnet names to IDs"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.main : s.id if s.tags["IsPublic"] == "true"]
  description = "List of public subnet IDs"
}

output "instance_details" {
  value = {
    id         = aws_instance.web.id
    public_ip  = aws_instance.web.public_ip
    private_ip = aws_instance.web.private_ip
    tags       = aws_instance.web.tags
  }
  description = "EC2 instance details as object"
}

output "environment_summary" {
  value       = "VPC ${aws_vpc.main.id} in ${var.environment} with ${length(aws_subnet.main)} subnets"
  description = "One-line environment summary"
}
