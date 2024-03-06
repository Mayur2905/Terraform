// This file is used to create an instance and security group in AWS.

// Author: Mayur Gaikwad


provider "aws" {
  region     = "us-west-1"
  access_key = "AKIATGNV2F7TOKKXWKMH"
  secret_key = "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"

}
resource "aws_instance" "this_instance" {
  ami = "ami-07619059e86eaaaa2"
  instance_type = "t2.micro"
  availability_zone = "us-west-1c"
  vpc_security_group_ids = [aws_security_group.this_security_group.id]
    key_name = "OmKey"
  tags = {
    Name = "Instance_by_MG"
  }
  
}

resource "aws_security_group" "this_security_group" {
  name = "Mg_Sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  } 
  tags = {
    name = "Security_Group_by_MG"
  }

}

