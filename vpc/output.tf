output "vpc-id" {
  value = aws_vpc.my-vpc.id
}



output "puplicsubnet-id" {
  value = tolist(values(aws_subnet.publicsubnet)[*].id)

}

output "privatesubnet-id" {
  value = tolist(values(aws_subnet.privatesubnet)[*].id)

}