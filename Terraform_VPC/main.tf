provider "aws" {
    region = "us-west-1"
    profile = "configs"
    shared_config_files = ["/home/mayur/.aws/credentials"]
  
}

resource "aws_vpc" "this_vpc" {

  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "this_public" {
  vpc_id = aws_vpc.this_vpc.id
  availability_zone = "us-west-1c"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  //enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_subnet" "this_private" {
  vpc_id = aws_vpc.this_vpc.id
  availability_zone = "us-west-1a"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Private_Subnet"
  }  
}

resource "aws_internet_gateway" "this_gateway" {
  vpc_id = aws_vpc.this_vpc.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "this_route" {
  vpc_id = aws_vpc.this_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_gateway.id
  }
  tags = {
    Name = "Route public"
  }
}

resource "aws_route_table_association" "this_association" {
  subnet_id = aws_subnet.this_public.id
  route_table_id = aws_route_table.this_route.id
}

resource "aws_eip" "this_elastic" {
  domain = "vpc"
  tags = {
    Name = "Elastic_IP"
  }
}

resource "aws_nat_gateway" "this_nat" {
  allocation_id = aws_eip.this_elastic.id
  subnet_id = aws_subnet.this_public.id
}

resource "aws_route_table" "this_private_route" {
  vpc_id = aws_vpc.this_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this_nat.id 
  }
  tags = {
    Name = "Route private"
  }
}

resource "aws_route_table_association" "this_private_association" {
  subnet_id = aws_subnet.this_private.id
  route_table_id = aws_route_table.this_private_route.id
}

resource "aws_security_group" "this_security_group" {
  name = "Mg_Sg"
  vpc_id = aws_vpc.this_vpc.id
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
  ingress {
    from_port   = 3000
    to_port = 3000
    protocol = "tcp"
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



resource "aws_instance" "this_public_instance" {
  ami = var.this_ami
  instance_type = var.instance_type
  key_name = var.public_key
  subnet_id = aws_subnet.this_public.id
  user_data = file("${path.module}/script.sh")
  vpc_security_group_ids = [aws_security_group.this_security_group.id]
  tags = {
    Name = "Public_Instance"
  }
}
resource "aws_instance" "this_private_instance" {
  ami = var.this_ami
  instance_type = var.instance_type
  key_name = var.public_key
  subnet_id = aws_subnet.this_private.id
  tags = {
    Name = "Private_Instance"
  }

}