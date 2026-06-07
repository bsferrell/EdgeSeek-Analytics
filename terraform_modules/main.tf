terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
}

resource "aws_instance" "awsseeker01" {
  ami           = "ami-0236922087fa98b6e"
  instance_type = "t2.micro"
  vpc_security_group_ids = "sg-0c0ec6b46c87440aa"

  tags = {
    Name = "awsseeker01"
  }
}
