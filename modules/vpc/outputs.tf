output "vpc_id" {
  value = aws_vpc.wordpress_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.wordpress_vpc.cidr_block
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_1.id, 
    aws_subnet.private_subnet_2.id]
}
