#variable "subnet_ids" {
 # description = "The subnet IDs where the EC2 instance should be launched"
  #type        = list(string)  # Make sure it's a list of strings, not a single string
#}


variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be launched."
  type        = string
}

variable "efs_id" {
  description = "The EFS ID to mount on EC2."
  type        = string
}

variable "db_endpoint" {
  description = "The RDS DB endpoint to connect to."
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to resources"
  type        = string
}

# ec2/variables.tf
variable "subnet_id" {
    description = "Subnet ID to launch the instance in"
      type        = string
}

variable "wordpress_tg_arn" {
  description = "ARN of the target group for WordPress instances"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for Auto Scaling Group"
  type        = list(string)
}

