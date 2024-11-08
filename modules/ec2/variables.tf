variable "subnet_ids" {
  description = "The list of subnet IDs where the EC2 instance will be launched."
  type        = list(string)
}

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
