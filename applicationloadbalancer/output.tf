#Load_Balancer_DNS
output "lb-dns" {

  value = aws_lb.application-lb.dns_name

}

output "Targetgroup_arn" {
  value       = aws_lb_target_group.NLB_tg.arn
}