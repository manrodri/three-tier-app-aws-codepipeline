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

resource "aws_alb" "webapp_elb" {
  subnets = module.vpc.public_subnets
  security_groups = [
    aws_security_group.webapp_https_inbound_sg.id,
    aws_security_group.webapp_http_inbound_sg.id
  ]
}

# Basic https lisener to demo HTTPS certiciate
resource "aws_alb_listener" "mylb_https" {
  load_balancer_arn = aws_alb.webapp_elb.arn
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn
  port              = "443"
  protocol          = "HTTPS"
  # Default action, and other paramters removed for BLOG
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<html><body><h1>Hello World!</h1><p>This would usually be to a target group of web servers.. but this is just a demo to returning a fixed response\n\n</p></body></html>"
      status_code  = "200"
    }
  }
}

# Always good practice to redirect http to https
resource "aws_alb_listener" "webapp_elb_http" {
  load_balancer_arn = aws_alb.webapp_elb.arn
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
  load_balancers        = [aws_alb.webapp_elb.name]

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
