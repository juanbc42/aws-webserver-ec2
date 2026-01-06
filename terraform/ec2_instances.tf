resource "aws_key_pair" "deployer" {
  key_name   = "ec2-ssh-deployer-key"
  public_key = file("~/.ssh/id_rsa.pem.pub")
}

data "template_file" "user_data" {
  template = file("user_datascript.tpl")
  vars = {
    tf_region      = var.region
    tf_secret_name = data.aws_secretsmanager_secret.deploy_key.name
  }
}

resource "aws_instance" "main" {
  for_each                    = 3
  ami                         = "ami-0341d95f75f311023" # Amazon Linux 2023 Kernel > 6.1
  instance_type               = "t3.medium"             # GPU NVIDIA T4: g4dn.xlarge
  subnet_id                   = aws_subnet.main.id
  key_name                    = aws_key_pair.deployer.key_name
  user_data_replace_on_change = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = data.template_file.user_data.rendered

  vpc_security_group_ids = [
    aws_security_group.allow_all_outbond.id,
    aws_vpc_security_group_ingress_rule.allow_ipv4.id
  ]

  root_block_device {
    volume_size = 16
    volume_type = "gp3"
    tags = {
      Name = "root_block_device_ai"
    }
  }
  tags = {
    Name = "websrv-${each.key}"

  }
}

## If EC2 in private subnet, uncomment below
# resource "aws_vpc_endpoint" "sm_interface" { 
#   vpc_id = aws_vpc.main.id 
#   service_name = "com.amazonaws.${var.region}.secretsmanager" 
#   vpc_endpoint_type = "Interface" 
#   subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id] 
#   security_group_ids = [aws_security_group.vpc_endpoint.id] 
# }

# resource "aws_security_group" "vpc_endpoint" { 
#   name = "sm-endpoint-sg" 
#   vpc_id = aws_vpc.main.id
#   ingress { 
#     description = "HTTPS from VPC" 
#     from_port = 443 
#     to_port = 443 
#     protocol = "tcp" 
#     cidr_blocks = [aws_vpc.main.cidr_block] 
#   } 
#   egress {
#     from_port = 0 
#     to_port = 0 
#     protocol = "-1" 
#     cidr_blocks = ["0.0.0.0/0"] 
#     } 
# }
