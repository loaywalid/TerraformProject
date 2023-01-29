resource "aws_lb" "nlb" {
  name               = var.name
  internal           = var.nlb-internal
  load_balancer_type = "network"
  subnets            = var.subnets
}



resource "aws_lb_target_group" "NLB-tg" {
  name     = var.targetgroup-name
  port     = var.targetgroup-port
  protocol = var.targetgroup-protocol
  vpc_id   = var.vpcid

  health_check {
    enabled  = true
    protocol = var.healthcheck-protocol
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(var.ec2ids)
  target_group_arn = aws_lb_target_group.NLB-tg.arn
  target_id        = element(var.ec2ids, count.index)
  port             = var.tgattachment-port

  depends_on = [
    aws_lb_target_group.NLB-tg
  ]

}




resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.nlb.arn

  protocol = var.listener-protocol
  port     = var.listener-port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.NLB-tg.arn
  }
}