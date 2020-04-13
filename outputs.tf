output "ec2_public_dns" {
  value = aws_instance.app_instance.public_dns
}
output "public_dns" {
  value = aws_instance.app_instance.public_ip
}
output "public_eip" {
  value = aws_eip.gw.public_ip
}
