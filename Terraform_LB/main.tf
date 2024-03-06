// Create a Load Balancer and attach two instances to it and create a target group and attach instances to it.

// Author: Mayur Gaikwad


resource "aws_vpc" "Mg_VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Mg_VPC"
    Dev  = "Mg"
  }
}

resource "aws_subnet" "Mg_Subnet" {
  vpc_id     = aws_vpc.Mg_VPC.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    name = "Mg_Subnet"
    Dev  = "Mg"
  }
}


resource "aws_subnet" "Mg_Subnet_2" {
  vpc_id     = aws_vpc.Mg_VPC.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
    tags = {
        name = "Mg_Subnet_2"
        Dev  = "Mg"
    }
  
}

resource "aws_route_table_association" "this_rt_association" {
  subnet_id      = aws_subnet.Mg_Subnet.id
  route_table_id = aws_route_table.Mg_RouteTable.id
}

resource "aws_route_table_association" "this_rt2_association" {
  subnet_id      = aws_subnet.Mg_Subnet_2.id
  route_table_id = aws_route_table.Mg_RouteTable.id
  
}


resource "aws_internet_gateway" "Mg_IGW" {
  vpc_id = aws_vpc.Mg_VPC.id
  tags = {
    Name = "Mg_IGW"
    Dev  = "Mg"
  }
}

resource "aws_route_table" "Mg_RouteTable" {
  vpc_id = aws_vpc.Mg_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Mg_IGW.id
  }
  tags = {
    Name = "Mg_RouteTable"
    Dev  = "Mg"
  }
}

resource "aws_security_group" "Mg_SG" {
  name   = "Mg_SG"
  vpc_id = aws_vpc.Mg_VPC.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "Mg_SG"
    Dev  = "Mg"
  }

}

resource "aws_instance" "Mg_Instance_1" {
  ami             = var.aws_ami
  instance_type   = "t2.micro"
  key_name        = var.security_key
  security_groups = [aws_security_group.Mg_SG.id]
  subnet_id       = aws_subnet.Mg_Subnet.id
  tags = {
    Name = "Mg_Instance_1"
    Dev  = "Mg"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo -i
                yum update -y
                yum install -y httpd
                systemctl start httpd
                echo "Hello is page from $HOSTNAME" >> /var/www/html/index.html
                EOF
}

resource "aws_instance" "Mg_Instance_2" {
  ami             = var.aws_ami
  instance_type   = "t2.micro"
  key_name        = var.security_key
  security_groups = [aws_security_group.Mg_SG.id]
  subnet_id       = aws_subnet.Mg_Subnet_2.id
  tags = {
    Name = "Mg_Instance_2"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo -i
                yum update -y
                yum install -y httpd
                systemctl start httpd
                echo "Hello is page from $HOSTNAME" >> /var/www/html/index.html
                EOF

}

resource "aws_lb_target_group" "Mg_TagetGroup" {
  name     = "MgTageGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Mg_VPC.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

}

resource "aws_lb_target_group_attachment" "this_attachment1" {
  target_group_arn = aws_lb_target_group.Mg_TagetGroup.arn
  target_id        = aws_instance.Mg_Instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "this_attachment2" {
  target_group_arn = aws_lb_target_group.Mg_TagetGroup.arn
  target_id        = aws_instance.Mg_Instance_2.id
  port             = 80
}

resource "aws_lb" "this_alb" {
  name               = "this-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Mg_SG.id]
  subnets            = [aws_subnet.Mg_Subnet.id, aws_subnet.Mg_Subnet_2.id]
  enable_deletion_protection = false
  tags = {
    Name = "this-alb"
    dev  = "Mg"
  }

}

resource "aws_alb_listener" "this_listener" {
  load_balancer_arn = aws_lb.this_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Mg_TagetGroup.arn
  } 
  
}