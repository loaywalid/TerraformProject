output "public-ec2-ip" {
  value = tolist(aws_instance.pubilc-ec2.*.id)
}
output "private-ec2-ip" {
    value =tolist(aws_instance.private-ec2.*.id)
}