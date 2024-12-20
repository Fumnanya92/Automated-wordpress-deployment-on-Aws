# Backend configuration for Terraform state management
terraform {
  backend "s3" {
    bucket         = "capstone-terraform-state-bucket" # Replace with your bucket name
    key            = "terraform/terraform.tfstate"     # Replace with a custom path
    region         = "us-west-2"                       # Replace with your bucket region
    dynamodb_table = "capstone-terraform-state-bucket" # Replace with your DynamoDB table name
    encrypt        = true                              # Enable encryption for added security
  }
}



# VPC Module Configuration
module "vpc" {
  source = "./modules/vpc"

  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

# Security Group Configuration for WordPress and RDS instances
resource "aws_security_group" "wordpress_sg" {
  name_prefix = "wordpress-sg"
  description = "Security group for WordPress and RDS instances"
  vpc_id      = module.vpc.vpc_id

  # HTTP (80) - Allow for web access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS (443) - Allow for secure web access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL (3306) - Allow access from allowed CIDR blocks
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # SSH (22) - Allow access dynamically from EC2 instance IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Reference EC2 public IP
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow incoming traffic from ALB to WordPress instance
resource "aws_security_group_rule" "allow_alb_access" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wordpress_sg.id
  source_security_group_id = module.alb.alb_sg_id # ALB security group ID from the alb module
}

# RDS Module Configuration
module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  allocated_storage   = 20
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = aws_security_group.wordpress_sg.id
}

# EFS Module Configuration
module "efs" {
  source              = "./modules/efs"
  subnet_ids          = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
  security_group_id   = aws_security_group.wordpress_sg.id # Passing SG to module
}

# EC2 Module Configuration
module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.public_subnet_1_id # Use public subnet 1 for EC2
  vpc_id            = module.vpc.vpc_id
  efs_id            = module.efs.efs_id
  db_endpoint       = module.rds.rds_endpoint
  security_group_id = aws_security_group.wordpress_sg.id # Passing SG to module
  wordpress_tg_arn  = module.alb.wordpress_tg_arn        # Pass the target group ARN
  public_subnets    = module.vpc.public_subnet_ids       # Pass subnets here
}

# ALB Module Configuration
module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

