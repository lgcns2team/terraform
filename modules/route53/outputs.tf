output "zone_id" {
  description = "Route53 zone ID"
  value       = data.aws_route53_zone.main.zone_id
}

output "cloudfront_record" {
  description = "CloudFront DNS record"
  value       = aws_route53_record.cloudfront.fqdn
}

output "alb_record" {
  description = "ALB DNS record"
  value       = aws_route53_record.alb.fqdn
}
