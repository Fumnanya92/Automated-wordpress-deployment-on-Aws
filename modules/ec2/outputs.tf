output "public_ip" {
  value = aws_instance.wordpress_instance.public_ip
}

# Outputs for the Auto Scaling Group
output "autoscaling_group_id" {
  value = aws_autoscaling_group.wordpress_asg.id
}

output "launch_template_id" {
  value = aws_launch_template.wordpress_launch_template.id
}