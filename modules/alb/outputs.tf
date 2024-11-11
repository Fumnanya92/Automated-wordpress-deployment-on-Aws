output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "wordpress_tg_arn" {
  description = "Target group ARN for WordPress instances"
  value       = aws_lb_target_group.wordpress_target_group.arn
}

output "alb_sg_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb_sg.id  # Ensure this is the correct resource name
}
