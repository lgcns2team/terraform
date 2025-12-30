output "arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "ALB Zone ID"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.main.arn
}

output "listener_arn" {
  description = "HTTP Listener ARN"
  value       = aws_lb_listener.http.arn
}
