resource "aws_security_group" "securitygroup" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc-id

   ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.puplic-cidr]

  }
  
  ingress {
    from_port   = var.sgfp
    to_port     = var.sgtp
    protocol    = var.sg_protocol_ingress
    cidr_blocks = [var.puplic-cidr]

  }
  egress {
    from_port   = var.sgfpe
    to_port     = var.sgtpe
    protocol    = var.sg_protocol_egress
    cidr_blocks = [var.puplic-cidr]
  }
}