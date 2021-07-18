provider "aws" {
  region     = "ap-south-1"
}


variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}



resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc",
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

#internet gateway = virtual modem
resource "aws_internet_gateway" "myapp_igw" {
 vpc_id = aws_vpc.myapp-vpc.id
 tags = {
   Name: "${var.env_prefix}-igw"
 }
}

# route table = virutal router
resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp_igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}