terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  profile = var.environment == "local" ? null : "cloudmentor-admin"
  region  = "us-east-1"
  default_tags {
    tags = merge(var.instance_tags, {
      Project   = "Cloud-Core-180"
      Day       = "89"
      Topic     = "Terraform-Variables-Outputs"
      ManagedBy = "terraform"
    })
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "main" {
  for_each = { for s in var.subnet_configs : s.name => s }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name     = each.value.name
    IsPublic = tostring(each.value.public)
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = { for s in var.subnet_configs : s.name => s if s.public }

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.public.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main["day89-public-1a"].id
  monitoring    = var.enable_monitoring

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.environment}-web-server"
  }
}
