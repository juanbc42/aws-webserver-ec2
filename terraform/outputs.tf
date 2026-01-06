## AWS EC2 Instance Outputs
output "ec2_instance_arn" {
  value = aws_instance.main.arn
}
output "ec2_instance_state" {
  value = aws_instance.main.instance_state
}
output "ec2_instance" {
  value = aws_instance.main.instance_state
}
output "ec2_instance_public_ip" {
  value = aws_instance.main.public_ip
}
