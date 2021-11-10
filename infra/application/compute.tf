resource "aws_launch_configuration" "webapp_lc" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix   = "${terraform.workspace}-demo-lc"
  image_id      = data.aws_ami.ubuntu.image_id
  instance_type = var.asg_instance_size[terraform.workspace]
  key_name = var.key

  security_groups = [
    aws_security_group.webapp_http_inbound_sg.id,
    aws_security_group.webapp_ssh_inbound_sg.id,
    aws_security_group.webapp_https_inbound_sg.id
  ]

  user_data                   = file("./templates/userdata.sh")
  associate_public_ip_address = true
}

resource "aws_alb" "webapp_alb" {
  subnets = module.vpc.public_subnets
  security_groups = [
    aws_security_group.webapp_https_inbound_sg.id,
    aws_security_group.webapp_http_inbound_sg.id
  ]
}

resource "aws_alb_target_group" "webapp_alb_tg" {
  name = "${terraform.workspace}-demo-lb-tg"
  tags = local.common_tags
  protocol = "HTTPS"
  vpc_id = module.vpc.vpc_id
  port = 443
}



# Basic https listener to demo HTTPS certificate
resource "aws_alb_listener" "mylb_https" {
  load_balancer_arn = aws_alb.webapp_alb.arn
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn
  port              = "443"
  protocol          = "HTTPS"
  # Default action, and other paramters removed for BLOG
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.webapp_alb_tg.arn
  }
}

# Always good practice to redirect http to https
resource "aws_alb_listener" "webapp_elb_http" {
  load_balancer_arn = aws_alb.webapp_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_autoscaling_group" "webapp_asg" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_zone_identifier   = module.vpc.public_subnets
  name                  = "demo_webapp_asg-${terraform.workspace}"
  max_size              = var.asg_max_size[terraform.workspace]
  min_size              = var.asg_min_size[terraform.workspace]
  wait_for_elb_capacity = var.asg_min_size[terraform.workspace]
  force_delete          = true
  launch_configuration  = aws_launch_configuration.webapp_lc.id

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_attachment" "webapp_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.id
  alb_target_group_arn = aws_alb_target_group.webapp_alb_tg.arn
}


######################
# autoscaling policies
#######################

#
# Scale Up Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "demo_asg_scale_up-${terraform.workspace}"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name                = "demo-high-asg-cpu-${terraform.workspace}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

#
# Scale Down Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "demo_asg_scale_down-${terraform.workspace}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 600
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name                = "demo-low-asg-cpu-${terraform.workspace}"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}