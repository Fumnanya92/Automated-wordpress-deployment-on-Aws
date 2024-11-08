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

## Project Deliverables

### Documentation:
- Detailed documentation for each component setup
- Explanation of security measures implemented

### Demonstration:
- Live WordPress site demo
- Showcase auto-scaling by simulating traffic increase

---

## Project Components

### 1. VPC Setup

#### Architecture Overview
- VPC with public and private subnets in 2 Availability Zones.
- An Internet Gateway for external communication.
- Public subnets for resources like NAT Gateway, Bastion Host, and ALB.
- Private subnets for web servers and database servers.

#### Objective
Create a Virtual Private Cloud (VPC) to isolate and secure the WordPress infrastructure.

#### Steps
1. Define IP address range for the VPC.
2. Create VPC with both public and private subnets.
3. Configure route tables for each subnet.

#### Terraform Instructions
- Use Terraform to define VPC, subnets, and route tables.
- Leverage variables for customization.
- Document Terraform commands for execution.

### 2. Public and Private Subnets with NAT Gateway

#### Architecture Overview
- NAT Gateway allows instances in private subnets to access the internet.
- Private Route Table is associated with private subnets, routing traffic through the NAT Gateway.

#### Objective
Implement a secure network with public and private subnets and use a NAT Gateway for private subnet internet access.

#### Steps
1. Set up a public subnet for resources needing internet access.
2. Create a private subnet for secure resources.
3. Configure a NAT Gateway to allow private subnet internet access.

#### Terraform Instructions
- Use Terraform to define subnets, security groups, and NAT Gateway.
- Associate resources with the appropriate subnets.
- Document Terraform commands for execution.


# Step 1: Cloning the Repository

1. **Clone the Repository**  
   Start by cloning your repository to your local machine:
   ```bash
   git clone https://github.com/YourUsername/Automated-Wordpress-deployment-on-AWS.git
   cd Automated-Wordpress-deployment-on-AWS
   ```

---

# Step 2: Directory and Module Structure

1. **Create the Directory Structure**  
   Set up the directories for organizing Terraform configurations:
   ```bash
   mkdir -p terraform/modules/vpc
   mkdir terraform/environments
   ```

2. **Initialize VPC Module**  
   In the `terraform/modules/vpc` directory, create the following files:
   - `main.tf`: Main configurations for the VPC setup.
   - `variables.tf`: Defines variables for the VPC module.
---

# Step 3: Configuring the VPC Module

### 1. `main.tf`

Define the VPC, public and private subnets, internet gateway, NAT gateway, and route tables. This configuration isolates and secures the WordPress infrastructure.

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
  tags = {
    Name = "wordpress-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zone_1
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_2
  tags = {
    Name = "private-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = {
    Name = "wordpress-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = {
    Name = "public-route-table"
  }
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
  tags = {
    Name = "private-route-table"
  }
}
```

### 2. `variables.tf`

Define variables for the VPC configuration to allow customization.

```hcl
# vpc/variables.tf

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
```

### 3. `outputs.tf`

Output key information about the VPC and subnets for easy reference.

```hcl
# outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.wordpress_vpc.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private_subnet_2.id
}
```
## In the root main.tf, reference the VPC module and pass the variables:
```
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
 Create variables.tf file in the modules/vpc, and declare the same variables:
```
variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}
```
 
---

# Step 4: Initializing and Deploying the VPC

1. **Initialize Terraform**  
   Run this command in the root directory:
   ```bash
   terraform init
   ```
   
2. **Plan the Deployment**  
   Preview the resources to be created:
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**  
   Deploy the VPC, subnets, and route tables:
   ```bash
   terraform apply
   ```

   Confirm with `yes` when prompted.

---


### 3. AWS MySQL RDS Setup

#### Security Group Architecture
- **ALB Security Group**: Ports 80 & 443, Source = 0.0.0.0/0
- **SSH Security Group**: Port 22, Source = Your IP Address
- **Webserver Security Group**: Ports 80 & 443, Source = ALB and SSH Security Groups
- **Database Security Group**: Port 3306, Source = Webserver Security Group
- **EFS Security Group**: Ports 2049 & 22, Source = Webserver and SSH Security Groups

#### Objective
Deploy a managed MySQL database using Amazon RDS to store WordPress data.

#### Steps
1. Create an Amazon RDS instance with the MySQL engine.
2. Configure security groups to control access to the RDS instance.
3. Connect WordPress to the RDS database.

#### Terraform Instructions
- Define Terraform scripts for creating the RDS instance.
- Set up security groups and required parameters.
- Document Terraform commands for execution.

### Step 1: Create the Directory Structure for RDS

1. In the `modules` directory, create a folder named `rds`.
   ```bash
   mkdir -p modules/rds
   ```

2. Inside `modules/rds`, create three files:
   - `main.tf` – for defining the RDS instance and security groups.
   - `variables.tf` – for input variables.
   - `outputs.tf` – for any output values that may be useful.

### Step 2: Define the RDS Module Configuration

#### `modules/rds/main.tf`

Define the RDS instance and its security groups here.

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

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port = 22
    to_port =22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  description = "Subnet group for RDS instance"
  subnet_ids = var.private_subnet_ids
}

```

#### `modules/rds/variables.tf`

Define input variables for the RDS module.

```hcl
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

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Allowed CIDR blocks for access to RDS"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS deployment"
}

variable "db_name" {
  description = "The database name for WordPress"
  type        = string
  default     = "wordpress_db"
}

variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The VPC ID where the RDS instance will be deployed"
  type        = string
}

```

#### `modules/rds/outputs.tf`

Define outputs for use outside of the module, such as the RDS endpoint.

```hcl
output "rds_endpoint" {
  value = aws_db_instance.wordpress_rds.endpoint
  description = "RDS instance endpoint"
}
```

### Step 3: Call the RDS Module from Root `main.tf`

In the root `main.tf`, add a new `module` block to call the RDS module and pass in necessary variables.

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
  #vpc_security_group_ids = [module.vpc.vpc_id] # Ensure security groups are in the correct VPC
}
```

### Step 4: Add Database Variables in Root `variables.tf`

In the root `variables.tf`, add variables for the database:

```hcl
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
```

### Step 5: Run the Terraform Commands

After setting up the module and variables, you can initialize and apply the configuration.

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Validate the configuration:
   ```bash
   terraform validate
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

### 4. EFS Setup for WordPress Files

#### Objective
Use Amazon Elastic File System (EFS) for scalable and shared WordPress file access.

#### Steps
1. Create an EFS file system.
2. Mount the EFS on WordPress instances.
3. Configure WordPress to use the shared file system.

#### Terraform Instructions
- Write Terraform scripts to create and configure the EFS file system.
- Define configurations to mount EFS on WordPress instances.
- Document Terraform commands for execution.

### 5. Application Load Balancer (ALB)

#### Objective
Set up an Application Load Balancer to evenly distribute traffic and ensure high availability.

#### Steps
1. Create an Application Load Balancer.
2. Configure listener rules to route traffic to instances.
3. Integrate the ALB with the Auto Scaling Group.

#### Terraform Instructions
- Use Terraform to define ALB configurations.
- Integrate the ALB with the Auto Scaling Group.
- Document Terraform commands for execution.

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

---

## Conclusion

This guide provides a structured approach to deploying a scalable, secure, and cost-effective WordPress website for DigitalBoost. By following the steps above, you’ll leverage Terraform for automation and ensure high availability and fault tolerance through AWS services.
