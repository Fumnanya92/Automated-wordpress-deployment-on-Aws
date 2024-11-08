# EFS file system
resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "wordpress-efs"
  }
}

# EFS Mount Target for each private subnet
resource "aws_efs_mount_target" "efs_mount_target" {
  count       = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

# Security Group for EFS
resource "aws_security_group" "efs_sg" {
  name_prefix = "efs-sg"
  description = "Security group for EFS access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
