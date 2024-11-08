module "vpc" {
  source = "./modules/vpc"

  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

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

module "efs" {
  source              = "./modules/efs"
  subnet_ids          = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
}

module "ec2" {
  source              = "./modules/ec2"
  subnet_ids          = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id
  efs_id              = module.efs.efs_id
 # allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
  db_endpoint         = module.rds.db_endpoint
}

terraform {
  backend "s3" {
    bucket         = "capstone-terraform-state-bucket" # Replace with your bucket name
    key            = "terraform/terraform.tfstate"     # Replace with a custom path
    region         = "us-west-2"                       # Replace with your bucket region
    dynamodb_table = "capstone-terraform-state-bucket" # Replace with your DynamoDB table name
    encrypt        = true                              # Enable encryption for added security
  }
}
