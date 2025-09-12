# create load balancer
resource "aws_elb" "web_elb" {
  name               = "web-elb"
  security_groups    = [var.web_security_group]
  subnets            = var.public_subnets_list

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }



  tags = {
    Name = "web-elb"
  }
  
}