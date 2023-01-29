resource "aws_vpc" "my-vpc" {

    cidr_block = var.vpc-cidr

    tags = {
        "Name" = var.vpc-name
    }
}


resource "aws_subnet" "publicsubnet" {
  for_each = { for idx, subnet in keys(var.publicsubnet-cidr) :
    idx => {
      name = subnet
      cidr = var.publicsubnet-cidr[subnet]
    }
  }
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = {
    Name = "public ${each.key}"
  }
}


resource "aws_subnet" "privatesubnet" {
  for_each = { for idx, subnet in keys(var.privatesubnet-cidr) :
    idx => {
      name = subnet
      cidr = var.privatesubnet-cidr[subnet]
    }
  }
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = each.value.cidr
  availability_zone = element(data.aws_availability_zones.available.names, each.key)

  tags = {
    Name = "private ${each.key}"
  }
}




data "aws_availability_zones" "available" {
  state = "available"
}




