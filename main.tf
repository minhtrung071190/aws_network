

#----------------------------------------------------------
# ACS730 - Lab 3 - Terraform Introduction
#
# Build EC2 Instances
#
#----------------------------------------------------------

# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}
locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}
# Resource for default VPC id
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(local.default_tags, {
    "Name" = "${var.prefix}-public-subnet"
    }
  )
}
#Create subnet using count.index
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.default_tags, {
    "Name" = "${var.prefix}-public-subnet-${count.index}"
    }
  )
}
#Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.default_tags, {
    "Name" = "${var.prefix}-igw"
    }
  )
}
#Create route table to allow internet traffic from public subnet 
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
#Associate route table to subnet
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}