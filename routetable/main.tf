resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc-id

  route {
    cidr_block     = var.puplic-cidr
    nat_gateway_id = var.natgateway-id
    gateway_id     = var.ig-id
  }

  tags = {
    Name = var.tableName
  }
}

resource "aws_route_table_association" "subnetassoprivate" {
  count          = length(var.subnetsid)
  subnet_id      = var.subnetsid[count.index]
  route_table_id = aws_route_table.private_rt.id
}
