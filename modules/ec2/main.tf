resource "tls_private_key" "wordpress" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "wordpress_keypair" {
  key_name   = "tfkey"
  public_key = tls_private_key.wordpress.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.wordpress.private_key_pem
  filename = "tfkey"
}

resource "aws_instance" "wordpress_instance" {
  ami               = "ami-066a7fbea5161f451" # Specify the correct AMI ID for your region
  instance_type     = "t3.micro"
  key_name          = aws_key_pair.wordpress_keypair.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id] # Ensure correct SG is linked

  # Use the updated user_data with the EFS ID from the module
  user_data = templatefile("${path.module}/userdata.sh", {
    efs_id = var.efs_id
  })

  tags = {
    Name = "wordpress-instance"
  }
}
