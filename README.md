# Terraform Capstone Project: Automated WordPress Deployment on AWS

## Project Scenario

**DigitalBoost** aims to elevate its online presence by launching a high-performance WordPress website. As an AWS Solutions Architect, your task is to design and implement a scalable, secure, and cost-effective WordPress solution using AWS services. The deployment process will be automated using Terraform for efficiency and reproducibility.

---

## Prerequisites

- Knowledge of TechOns Essentials
- Completion of Core 2 Courses and Mini Projects

---

## Project Overview

### Architecture Summary

1. **VPC**: Public and private subnets in 2 availability zones.
2. **Internet Gateway**: Allows VPC instances to communicate with the internet.
3. **NAT Gateway**: Enables instances in private subnets to access the internet securely.
4. **MYSQL RDS Database**: Managed database for WordPress data storage.
5. **Amazon EFS**: Shared file system for scalable web server access.
6. **EC2 Instances**: Hosts the WordPress application.
7. **Application Load Balancer (ALB)**: Distributes incoming traffic across an auto-scaling group.
8. **Auto Scaling Group**: Dynamically creates EC2 instances to ensure high availability.
---

Here’s a step-by-step markdown document for the tasks you've outlined.

---

# WordPress Infrastructure Setup on AWS

## Table of Contents
1. [VPC Setup](#vpc-setup)
   - [VPC Architecture](#vpc-architecture)
   - [Objective](#objective)
   - [Steps](#steps)
   - [Instructions for Terraform](#instructions-for-terraform)
2. [Public and Private Subnet with NAT Gateway](#public-and-private-subnet-with-nat-gateway)
   - [NAT Gateway Architecture](#nat-gateway-architecture)
   - [Objective](#objective-1)
   - [Steps](#steps-1)
   - [Instructions for Terraform](#instructions-for-terraform-1)
3. [Terraform Configuration](#terraform-configuration)
   - [main.tf](#maintf)
   - [variables.tf](#variablestf)
   - [outputs.tf](#outputstf)
4. [Deploying the VPC](#deploying-the-vpc)
   - [Initialize Terraform](#initialize-terraform)
   - [Plan the Deployment](#plan-the-deployment)
   - [Apply the Configuration](#apply-the-configuration)

---

## VPC Setup

### VPC Architecture

1. **VPC with public and private subnets in 2 availability zones.**
2. **Internet Gateway** for communication between VPC instances and the Internet.
3. **Two Availability Zones** to ensure high availability and fault tolerance.
4. **Public Subnets** for resources like NAT Gateway, Bastion Host, and Application Load Balancer.
5. **Private Subnets** for webservers and database servers, providing added protection.
6. **Public Route Table** associated with public subnets, routing traffic to the Internet via the Internet Gateway.
7. **Main Route Table** associated with the private subnets.

### Objective

Create a Virtual Private Cloud (VPC) to isolate and secure the WordPress infrastructure.

### Steps

1. Define IP address range for the VPC.
2. Create VPC with public and private subnets.
3. Configure route tables for each subnet.

### Instructions for Terraform

- Use Terraform to define the VPC, subnets, and route tables.
- Leverage variables for customization.
- Document Terraform commands for execution.

---

## Public and Private Subnet with NAT Gateway

### NAT Gateway Architecture

- **NAT Gateway** enables instances in private App and Data subnets to access the internet.
- **Private Route Table** routes traffic from private subnets to the Internet through the NAT Gateway.

### Objective

Implement a secure network architecture with public and private subnets, and enable internet access for the private subnet using a NAT Gateway.

### Steps

1. Set up a public subnet for internet-accessible resources.
2. Create a private subnet for resources without direct internet access.
3. Configure a NAT Gateway for internet access in private subnets.

### Instructions for Terraform

- Use Terraform to define subnets, security groups, and NAT Gateway.
- Ensure resources are associated with the appropriate subnets.
- Document Terraform commands for execution.

---

## Terraform Configuration

### main.tf

Define the VPC, public and private subnets, internet gateway, NAT gateway, and route tables to isolate and secure the WordPress infrastructure.

```hcl
# vpc/main.tf

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "wordpress-vpc" }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-1" }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-2" }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1
  tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_2
  tags = { Name = "private-subnet-2" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = { Name = "wordpress-igw" }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = { Name = "public-route-table" }
}

# Route for Internet Gateway in Public Route Table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table (Main Route Table)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = { Name = "private-route-table" }
}
```

### variables.tf

Define variables for VPC configuration, enabling customization.

```hcl
# vpc/variables.tf

variable "aws_region" { default = "us-west-2" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_1_cidr" { default = "10.0.1.0/24" }
variable "public_subnet_2_cidr" { default = "10.0.2.0/24" }
variable "private_subnet_1_cidr" { default = "10.0.3.0/24" }
variable "private_subnet_2_cidr" { default = "10.0.4.0/24" }
variable "availability_zone_1" { default = "us-west-2a" }
variable "availability_zone_2" { default = "us-west-2b" }
```

### outputs.tf

Output key information about the VPC and subnets for easy reference.

```hcl
# outputs.tf

output "vpc_id" { value = aws_vpc.wordpress_vpc.id }
output "public_subnet_1_id" { value = aws_subnet.public_subnet_1.id }
output "public_subnet_2_id" { value = aws_subnet.public_subnet_2.id }
output "private_subnet_1_id" { value = aws_subnet.private_subnet_1.id }
output "private_subnet_2_id" { value = aws_subnet.private_subnet_2.id }
```

### Root main.tf - Reference the VPC Module

In the root `main.tf`, reference the VPC module and pass the necessary variables.

```hcl
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}
```

---

## Deploying the VPC

### Initialize Terraform

Run the following command in the root directory:

```bash
terraform init
```

### Plan the Deployment

Preview the resources to be created:

```bash
terraform plan
```

### Apply the Configuration

Deploy the VPC, subnets, and route tables:

```bash
terraform apply
```

Confirm with `yes` when prompted.

---

### 3. AWS MySQL RDS Setup

#### Security Group Architecture
- **ALB Security Group**: Allow ports 80 & 443, Source: `0.0.0.0/0`
- **SSH Security Group**: Allow port 22, Source: Your IP Address
- **Webserver Security Group**: Allow ports 80 & 443, Source: ALB and SSH Security Groups
- **Database Security Group**: Allow port 3306, Source: Webserver Security Group
- **EFS Security Group**: Allow ports 2049 & 22, Source: Webserver and SSH Security Groups

#### Objective
Deploy a managed MySQL database using Amazon RDS to store WordPress data.

#### Steps
1. Create an Amazon RDS instance with the MySQL engine.
2. Configure security groups to control access to the RDS instance.
3. Connect WordPress to the RDS database.

---

### Terraform Instructions
- Define Terraform scripts for creating the RDS instance.
- Set up security groups and required parameters.
- Document Terraform commands for execution.

---

### Step 1: Create the Directory Structure for RDS

1. In the `modules` directory, create a folder named `rds`:
   ```bash
   mkdir -p modules/rds
   ```

2. Inside `modules/rds`, create three files:
   - `main.tf` – for defining the RDS instance and security groups.
   - `variables.tf` – for input variables.
   - `outputs.tf` – for any output values that may be useful.

---

### Step 2: Define the RDS Module Configuration

#### `modules/rds/main.tf`

Define the RDS instance and its security groups:

```hcl
resource "aws_db_instance" "wordpress_rds" {
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false

  # Attach the security group and subnet group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
}
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg"
  description = "Security group for RDS MySQL instance"
  vpc_id      = var.vpc_id  # Ensure VPC ID is passed in from main.tf

  # Allow MySQL access from specified CIDR blocks
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow SSH access (if necessary) from any IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name        = "rds-subnet-group"
  description = "Subnet group for RDS instance"
  subnet_ids  = var.private_subnet_ids
}
```

---

#### `modules/rds/variables.tf`

Define input variables to customize the RDS configuration.

```hcl
variable "allocated_storage" {
  type        = number
  description = "Allocated storage for the RDS instance (in GB)"
  default     = 20
}

variable "engine_version" {
  type        = string
  description = "MySQL engine version for the RDS instance"
  default     = "8.0"
}

variable "instance_class" {
  type        = string
  description = "Instance class for the RDS instance"
  default     = "db.t3.micro"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the RDS instance"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS deployment"
}

variable "db_name" {
  type        = string
  description = "Database name for WordPress"
  default     = "wordpress_db"
}

variable "db_username" {
  type        = string
  description = "Master username for the RDS instance"
  default     = "admin"
}

variable "db_password" {
  type        = string
  description = "Master password for the RDS instance"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for deploying the RDS instance"
}
```
#### `modules/rds/outputs.tf`

```hcl
output "rds_endpoint" {
  value       = aws_db_instance.wordpress_rds.endpoint
  description = "RDS instance endpoint"
}
```

---

### Step 3: Reference the RDS Module in Root `main.tf`

Add a `module` block in the root `main.tf` to call the RDS module and pass in the necessary variables.

```hcl
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
}
```

---

### Step 4: Define Database Variables in Root `variables.tf`

Add database-related variables in the root `variables.tf` file to manage RDS instance configurations.

```hcl
variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "us-west-2b"
}

variable "db_name" {
  type        = string
  description = "Database name for WordPress"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "admin"  # Set a default or remove for required input
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}
```

```markdown
### Step 5: Deploy the Terraform Configuration

With all configurations set, proceed to initialize and apply the Terraform setup.

1. **Initialize Terraform**  
   Run the following command in the root directory to initialize the configuration:
   ```bash
   terraform init
   ```

2. **Validate the Configuration**  
   Confirm that the configuration is valid:
   ```bash
   terraform validate
   ```

3. **Preview the Plan**  
   Review the resources that will be created or modified:
   ```bash
   terraform plan
   ```

4. **Apply the Configuration**  
   Deploy the RDS, VPC, and EFS configurations:
   ```bash
   terraform apply
   ```
   Confirm with `yes` when prompted.

---

### Step 6: EFS Setup for WordPress Files

#### Objective
Implement Amazon Elastic File System (EFS) to enable scalable and shared file storage for WordPress.

#### Steps
1. **Create an EFS File System.**
2. **Mount the EFS on WordPress Instances.**
3. **Configure WordPress** to use the shared file system for persistent storage.

#### Terraform Configuration

- Set up Terraform scripts to create the EFS file system and mount points.
- Define configurations to integrate the EFS with WordPress instances.
- Document Terraform commands for deployment and management.

---

### `modules/efs/main.tf`

This file creates the EFS file system and associated mount targets in private subnets, enabling instances in your VPC to connect to the EFS.

```hcl
# EFS File System
resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "wordpress-efs"
  }
}

# EFS Mount Target for each Private Subnet
resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.security_group_id]
}
```

```markdown
### `module/efs/variables.tf`

Define input variables for the EFS module.

```hcl
variable "subnet_ids" {
  description = "List of private subnet IDs for the EFS mount targets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the EFS will be created"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to resources"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access EFS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
```

---

### `module/efs/outputs.tf`

Define outputs for the EFS module.

```hcl
output "efs_id" {
  description = "EFS File System ID"
  value       = aws_efs_file_system.efs.id
}
```

---

### Referencing EFS in `module/ec2/main.tf`

To link EFS to EC2, update `aws_instance` with a user data script to mount EFS, using `${module.efs.efs_id}` for the EFS ID.

#### `module/ec2/main.tf`

```hcl
# Generate SSH Key Pair for EC2
resource "tls_private_key" "wordpress" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "wordpress_keypair" {
  key_name   = "tfkey"
  public_key = tls_private_key.wordpress.public_key_openssh
}

# Save the private key locally
resource "local_file" "tf_key" {
  content  = tls_private_key.wordpress.private_key_pem
  filename = "tfkey"
}

# Create Elastic IP for the instance (optional for public access)
resource "aws_eip" "wordpress_eip" {
  domain = "vpc"  # Specifies that this is for use in a VPC
}

# EC2 Instance Configuration
resource "aws_instance" "wordpress_instance" {
  ami                         = "ami-066a7fbea5161f451"  # Replace with appropriate AMI ID
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.wordpress_keypair.key_name
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id  # Use the passed subnet ID
  associate_public_ip_address = true  # Associates a public IP

  # User data for EC2 instance configuration (e.g., EFS mounting)
  user_data = templatefile("${path.module}/userdata.sh", {
    efs_id = var.efs_id
  })

  tags = {
    Name = "wordpress-instance"
  }
}

# Associate Elastic IP with the instance (optional for dedicated IP)
resource "aws_eip_association" "wordpress_eip_association" {
  instance_id   = aws_instance.wordpress_instance.id
  allocation_id = aws_eip.wordpress_eip.id
}
```

---

### `userdata.sh`

User data script to mount EFS and install required packages.

```bash
#!/bin/bash
# Update packages
yum update -y

# Install necessary packages for EFS mounting
yum install -y amazon-efs-utils nfs-utils

# Create a directory to mount EFS
mkdir -p /var/www/html

# Mount EFS using the file system ID from Terraform
mount -t efs ${efs_id}:/ /var/www/html

# Make the mount persistent on reboot
echo "${efs_id}:/ /var/www/html efs defaults,_netdev 0 0" >> /etc/fstab

# Install Apache and PHP (if required for WordPress)
yum install -y httpd php

# Start and enable Apache on boot
systemctl start httpd
systemctl enable httpd
```

---

### Define Variables in Root Module

In the root `main.tf`, configure the EFS module by passing necessary variables, including `vpc_id` and security group IDs.

#### `main.tf`

```hcl
# EFS Module Configuration
module "efs" {
  source              = "./modules/efs"
  subnet_ids          = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
  security_group_id   = aws_security_group.wordpress_sg.id  # Passing SG to module
}
``` 

This setup creates an EFS file system, mounts it on the EC2 instance, and ensures the mount persists on reboot. The `efs_id` is dynamically passed into `userdata.sh` for configuration on each instance.

### Step 4: Document Terraform Commands

Use the following commands to deploy the EFS resources:

```bash
# Initialize Terraform
terraform init

# Apply configuration to set up EFS and related resources
terraform apply
```
---

### 5. Application Load Balancer (ALB)

#### Objective
Set up an Application Load Balancer (ALB) to distribute traffic evenly across instances, ensuring high availability.

#### Steps
1. Create an Application Load Balancer.
2. Configure listener rules to route traffic to instances.
3. Integrate the ALB with the Auto Scaling Group.

---

### Step 1: Set Up an Application Load Balancer Module

Create a new module in your `modules` directory (e.g., `modules/alb`) with the following configuration files.

#### 1. **`modules/alb/main.tf`**

```hcl
# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB
resource "aws_lb" "alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "wordpress-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener for HTTP
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}
```

#### 2. **`modules/alb/variables.tf`**

```hcl
variable "vpc_id" {
  description = "VPC ID for the load balancer"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}
```

#### 3. **`modules/alb/outputs.tf`**

```hcl
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}
```

---

### Step 2: Configure ALB Module in Your Main Terraform File

In your root `main.tf` file, add the ALB module:

```hcl
module "alb" {
  source        = "./modules/alb"
  vpc_id        = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}
```

```markdown
### Step 3: Update Security Group for WordPress Instances

Ensure your WordPress instances' security group allows traffic from the ALB’s security group:

```hcl
# Allow incoming traffic from ALB to WordPress instance
resource "aws_security_group_rule" "allow_alb_access" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wordpress_sg.id
  source_security_group_id = module.alb.alb_sg_id  # Replace with ALB security group
}
```

### Step 4: Configure Auto Scaling Group with Target Group

If you are using an Auto Scaling Group (ASG), add the ALB’s target group to it:

```hcl
# ALB Module Configuration

# Allow incoming traffic from ALB to WordPress instance
resource "aws_security_group_rule" "allow_alb_access" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.wordpress_sg.id
  source_security_group_id = module.alb.alb_sg_id # ALB security group ID from the alb module
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}
```

### Step 5: Run Terraform Commands

To apply these configurations, run the following Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

### Summary

- **ALB Module**: Defines the ALB, target group, and listeners.
- **Security Group Rule**: Grants ALB access to WordPress instances.
- **Auto Scaling Group**: Links ASG to the ALB’s target group.


### 6. Auto Scaling Group

#### Objective
Implement Auto Scaling to automatically adjust the number of instances based on traffic load.

#### Steps
1. Create an Auto Scaling group.
2. Define scaling policies using metrics like CPU utilization.
3. Configure launch configurations for instances.

#### Terraform Instructions
- Write Terraform scripts to create the Auto Scaling group.
- Set scaling policies and launch configurations.
- Document Terraform commands for execution.

## Steps: Create an `autoscaling.tf` file in the `module/ec2`

```hcl
# Launch Template for WordPress Instances
resource "aws_launch_template" "wordpress_launch_template" {
  name_prefix   = "wordpress-launch-template"
  image_id      = "ami-066a7fbea5161f451"  # Replace with your AMI ID
  instance_type = "t3.micro"

  key_name = aws_key_pair.wordpress_keypair.key_name  # Assuming the key pair is available in the root module

  network_interfaces {
    security_groups = [var.security_group_id]  # Security group ID passed from the main module
    associate_public_ip_address = true         # Associates a public IP for the instances
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    efs_id = var.efs_id
  }))

  tags = {
    Name = "wordpress-instance"
  }
}

# Auto Scaling Group for WordPress Instances
resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity        = 2                 # Adjust based on requirements
  max_size                = 3                 # Maximum number of instances
  min_size                = 1                 # Minimum number of instances

  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier     = var.public_subnets  # List of public subnets from VPC

  target_group_arns       = [var.wordpress_tg_arn]  # Target group ARN from ALB module
  health_check_type       = "ELB"                    # Use load balancer for health checks
  health_check_grace_period = 300                    # Grace period for instance health check

  tag {
    key                   = "Name"
    value                 = "wordpress-instance"
    propagate_at_launch   = true
  }
}

output "launch_template_id" {
  value = aws_launch_template.wordpress_launch_template.id
}




