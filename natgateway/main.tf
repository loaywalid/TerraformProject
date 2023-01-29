resource "aws_eip" "natgateway-ip" {
  vpc = true
}

resource "aws_nat_gateway" "lab3natgateway" {
  allocation_id = aws_eip.natgateway-ip.id
  subnet_id     = var.publicSubnetId

  tags = {
    Name = "lab3natgateway"
  }

  depends_on = [var.dependency]
}