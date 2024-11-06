# outputs.tf

output "vpc_cidr_block" {
  value = aws_vpc.wordpress_vpc.cidr_block
  description = "The CIDR block of the VPC"
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  description = "IDs of the private subnets"
}
