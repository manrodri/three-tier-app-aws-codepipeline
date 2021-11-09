output "testing" {
  value = "Test this demo code by going to https://${aws_route53_record.myapp.fqdn} and checking your have a valid SSL cert"
}
output "testing_sclient" {
  value = "Test this SSL by using openssl s_client -host ${aws_route53_record.myapp.fqdn} -port 443 and looking at the certs"
}