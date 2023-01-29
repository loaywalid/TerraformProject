output "nlb-dns" {
  value = aws_lb.nlb.dns_name
}

output "Targetgroup_arn" {
  value       = aws_lb_target_group.NLB-tg.arn
  description = "target group arn"
}