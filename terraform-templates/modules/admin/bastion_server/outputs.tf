output "bastion_ec2" {
  value = aws_instance.bastion_ec2
}
output "bastion_ec2_sg" {
  value = aws_security_group.bastion_ec2_sg.id
}