resource "aws_lb" "main" {
  name               = "main-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.main]

  enable_deletion_protection = true

  tags = {
    Name        = "main elb"
    Environment = "test"
  }
}