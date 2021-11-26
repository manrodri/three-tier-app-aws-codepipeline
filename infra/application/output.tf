output "testing" {
  value = "Test this demo code by going to https://${aws_route53_record.myapp.fqdn} and checking your have a valid SSL cert"
}
output "vpc_id" {
  description = "ID of project VPC"
  value       = module.vpc.vpc_id
}

output "certificate_arn" {
  value = aws_acm_certificate.myapp.arn
}