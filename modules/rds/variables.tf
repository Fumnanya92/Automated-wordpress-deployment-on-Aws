variable "allocated_storage" {
  type        = number
  description = "The allocated storage for the RDS instance in GB"
  default     = 20
}

variable "engine_version" {
  type        = string
  description = "The MySQL engine version for the RDS instance"
  default     = "8.0"
}

variable "instance_class" {
  type        = string
  description = "The instance class for the RDS instance"
  default     = "db.t3.micro"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
}

variable "username" {
  type        = string
  description = "The master username for the RDS instance"
}

variable "password" {
  type        = string
  description = "The master password for the RDS instance"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Allowed CIDR blocks for access to RDS"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS deployment"
}
