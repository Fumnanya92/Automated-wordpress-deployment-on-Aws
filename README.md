Here's a detailed markdown document for your project:

---

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
