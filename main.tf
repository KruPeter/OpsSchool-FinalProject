# Requirements
terraform {
  required_version = ">= 0.12"
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.4"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

# Setup the region in which to work.
provider "aws" {
    region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "VPC_Project" {
  cidr_block           = var.vpc_cidr
  # instance_tenancy     = default
  enable_dns_hostnames = true
  # enable_dns_support   = true

  tags = {
	Name = "Terraform_VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "IG_main" {
  vpc_id = aws_vpc.VPC_Project.id
  tags = {
    Name = "tf-cluster-main-gw"
  }
}

# Subnets : private
resource "aws_subnet" "private" {
  count                = length(var.subnets_cidr_private)
  vpc_id               = aws_vpc.VPC_Project.id
  cidr_block           = element(var.subnets_cidr_private,count.index)
  availability_zone    = element(var.azs, count.index)
  tags = {
    Name = "Subnet-private-${count.index+1}"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count                      = length(var.subnets_cidr_public)
  vpc_id                     = aws_vpc.VPC_Project.id
  cidr_block                 = element(var.subnets_cidr_public,count.index)
  availability_zone          = element(var.azs, count.index)
  # map_public_ip_on_launch    = true
  tags = {
    Name = "Subnet-public-${count.index+1}"
  }
}

# Create public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC_Project.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_main.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public" {
  count          = length(var.subnets_cidr_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

# Create private route tables
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.VPC_Project.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name    = "privetRouteTable"
    Service = "nat"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "private" {
  count          = length(var.subnets_cidr_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}