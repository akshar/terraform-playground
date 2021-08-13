provider "aws" {
  region = "ap-south-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs            = [var.avail_zone]
  public_subnets = [var.subnet_cidr_block]
  public_subnet_tags = {
    Name : "${var.env_prefix}-subnet-1",
  }

  tags = {
    Name : "${var.env_prefix}-vpc",
  }
}

# resource "aws_vpc" "myapp-vpc" {
#   cidr_block = var.vpc_cidr_block
#   tags = {
#     Name : "${var.env_prefix}-vpc",
#   }
# }



# module "myapp-subnet" {
#  source = "./modules/subnet"
#  subnet_cidr_block = var.subnet_cidr_block
#  avail_zone = var.avail_zone
#  env_prefix = var.env_prefix
#  vpc_id = aws_vpc.myapp-vpc.id
#  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
# }

module "myapp-webserver" {
  source              = "./modules/webserver"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.public_subnets[0]
  avail_zone          = var.avail_zone
  env_prefix          = var.env_prefix
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  image_name          = "amzn2-ami-hvm-*-x86_64-gp2"
}
