# Standard route53 DNS record for "myapp" pointing to an ALB
resource "aws_route53_record" "myapp" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.demo_dns_name}-${terraform.workspace}.${data.aws_route53_zone.public.name}"
  type    = "A"
  alias {
    name                   = aws_alb.webapp_alb.dns_name
    zone_id                = aws_alb.webapp_alb.zone_id
    evaluate_target_health = false
  }
}

