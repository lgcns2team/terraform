output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_a.id, aws_subnet.public_c.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_a.id, aws_subnet.private_c.id]
}

output "public_subnet_id" {
  description = "Primary public subnet ID"
  value       = aws_subnet.public_a.id
}

output "private_subnet_id" {
  description = "Primary private subnet ID"
  value       = aws_subnet.private_a.id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.private.id
}
