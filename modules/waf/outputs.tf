output "cloudfront_web_acl_id" {
  description = "CloudFront WAF Web ACL ID"
  value       = aws_wafv2_web_acl.cloudfront.id
}

output "alb_web_acl_id" {
  description = "ALB WAF Web ACL ID"
  value       = aws_wafv2_web_acl.alb.id
}

output "cloudfront_web_acl_arn" {
  description = "CloudFront WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.cloudfront.arn
}

output "alb_web_acl_arn" {
  description = "ALB WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.alb.arn
}
