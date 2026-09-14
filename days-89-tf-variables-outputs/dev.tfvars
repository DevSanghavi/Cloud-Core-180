environment = "dev"
vpc_cidr    = "10.89.0.0/16"

subnet_configs = [
  {
    name   = "day89-public-1a"
    cidr   = "10.89.1.0/24"
    az     = "us-east-1a"
    public = true
  },
  {
    name   = "day89-private-1a"
    cidr   = "10.89.2.0/24"
    az     = "us-east-1a"
    public = false
  }
]

instance_tags = {
  Owner       = "dev-sanghavi"
  CostCenter  = "learning"
  Environment = "dev"
}

enable_monitoring = true
