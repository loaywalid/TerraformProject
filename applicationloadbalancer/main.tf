resource "aws_lb" "application-lb" {
  name               = var.name
  internal           = var.lb_internal
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnets
}


resource "aws_lb_target_group" "NLB_tg" {
  name     = var.target_name
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpcid

  health_check {
    enabled  = true
    protocol = var.health_protocol
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(var.ec2ids)
  target_group_arn = aws_lb_target_group.NLB_tg.arn
  target_id        = element(var.ec2ids, count.index)
  port             = var.attach_target_port

  depends_on = [
    aws_lb_target_group.NLB_tg
  ]

}

resource "aws_lb_listener" "lblistener" {
  load_balancer_arn = aws_lb.application-lb.arn

  protocol = var.listener_protocol
  port     = var.listener_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.NLB_tg.arn
  }
}