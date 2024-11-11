variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
  default     = "us-west-2a"
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "us-west-2b"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
}

# variables.tf or terraform.tfvars
variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
  default     = "admin" # replace with your desired default, or remove this line to require input
}

variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access EFS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Declare missing variables
#variable "public_subnets" {
# description = "List of public subnet IDs"
#type        = list(string)
#}

#variable "wordpress_tg_arn" {
# description = "ARN of the ALB target group for WordPress"
#type        = string
#}
