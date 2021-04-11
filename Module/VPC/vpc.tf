

data "aws_availability_zones" "azs" {
  state = "available"
}

# VPC
resource "aws_vpc" "mc-vpc" {

  cidr_block                       = var.vpc-cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
    

  tags = {
      Name = var.vpc-name
      environment = var.env
  }
  
}

##public Subnet
resource "aws_subnet" "pub_sub" {

  count                   = length(var.vpc-public-subnet-cidr)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  cidr_block              = var.vpc-public-subnet-cidr[count.index]
  vpc_id                  = aws_vpc.mc-vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

tags = {

Name = "public-subnet-${count.index + 1}"

}

}


# Creating an Internet Gateway

resource "aws_internet_gateway" "igw" {
  
  vpc_id = aws_vpc.mc-vpc.id

    tags = {

      Name = "internet-gateway-name"
        }

}

# Public Routes

resource "aws_route_table" "public-routes" {
  vpc_id = aws_vpc.mc-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-subnet-routes"
  }
}

resource "aws_route_table_association" "public-association" {
  count          =  length(var.vpc-public-subnet-cidr)
  route_table_id = aws_route_table.public-routes.id
  subnet_id      = aws_subnet.pub_sub.*.id[count.index]
}


##Private subnet


resource "aws_subnet" "private_sub1" {

  count                   = length(var.vpc-private-subnet-cidr)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  cidr_block              = var.vpc-private-subnet-cidr[count.index]
  vpc_id                  = aws_vpc.mc-vpc.id

  tags = {

    Name = "private-subnet-${count.index + 1}"
  }

}

# Elastic IP For NAT-GateWay

resource "aws_eip" "eip-ngw" {
  count = var.total-nat-gateway-required
  
}

resource "aws_nat_gateway" "ngw" {
  count         = var.total-nat-gateway-required
  allocation_id = aws_eip.eip-ngw.*.id[count.index]
  subnet_id     = aws_subnet.pub_sub.*.id[count.index]
}

resource "aws_route_table" "private-routes" {
  count  =  length(var.vpc-private-subnet-cidr)
  vpc_id = aws_vpc.mc-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ngw.*.id,count.index)
  }

  tags = {
    Name = "Private-routes-${count.index + 1}"
  }
}


resource "aws_route_table_association" "private-routes-ass" {
  count          = length(var.vpc-private-subnet-cidr)
  subnet_id      = aws_subnet.private_sub1.*.id[count.index]
  route_table_id = aws_route_table.private-routes.*.id[count.index]
}

