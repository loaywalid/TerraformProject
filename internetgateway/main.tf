resource "aws_internet_gateway" "internetgatway" {
  
  vpc_id = var.vpc-id

  tags = {
    Name = var.ig-name
  }

}