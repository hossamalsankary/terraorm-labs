
# Read the app.sh script
locals {
  user_data = base64encode(file("${path.root}/app.sh"))
}




resource "aws_lb" "web_app_alb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_security_group]
  subnets            = var.public_subnets_list
  

  enable_deletion_protection = false

  tags = {
    Name = "web-app-alb"
  }
}


resource "aws_lb_target_group" "web_app_tg" {
  name     = "web-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 3
  }

  tags = {
    Name = "web-app-target-group"
  }
}


resource "aws_lb_listener" "web_app_listener" {
  load_balancer_arn = aws_lb.web_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    
    forward {
      target_group {
        arn = aws_lb_target_group.web_app_tg.arn
      }
    }
  }
}

# Launch Template
resource "aws_launch_template" "web_app_template" {
  name_prefix   = "web-app-template-"
  image_id      = "ami-00ca32bbc84273381"
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  user_data = local.user_data

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [var.web_security_group]
    delete_on_termination      = true
  }

 
  monitoring {
    enabled = true
  }


  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-app-instance"
      Type = "auto-scaled"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_app_asg" {
  name                = "web-app-asg"
  vpc_zone_identifier = var.private_subnets_list
  target_group_arns   = [aws_lb_target_group.web_app_tg.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 600  # 10 minutes for system update and app startup

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.web_app_template.id
    version = "$Latest"
  }


  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup = 300
      checkpoint_delay = 600
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "web-app-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "auto-scaled"
    propagate_at_launch = true
  }

  tag {
    key                 = "LaunchTemplateVersion"
    value               = aws_launch_template.web_app_template.latest_version
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "scale_up" {
  name                   = "web-app-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}


resource "aws_autoscaling_policy" "scale_down" {
  name                   = "web-app-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "web-app-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }
}


resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "web-app-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }
}
