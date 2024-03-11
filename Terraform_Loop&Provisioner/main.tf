provider "aws" {
  region     =""
  access_key = ""
  secret_key = ""
}

// With Count Loop
/* 
Use of count loop in terraform:
count loop is used to create multiple resources of the same type.
 */

resource "aws_instance" "example" {
  count = 3
  ami = "ami-022661f8a4a1b91cf"
  instance_type = "t2.micro"
}

output "instance_ip" {
  value = aws_instance.example.*.public_ip
}

# // Count with interpolation

resource "aws_iam_user" "this_user" {
  count = length(var.aws_name)
  name  = var.aws_name[count.index]
  path  = "/"
}

variable "aws_name" {
  type    = list(string)
  default = ["user1", "user2", "user3"]
}


// With For_each Loop
/* 
Use of for_each loop in terraform:
for_each loop is used to iterate over a map of values and create a resource for each value in the map.
 */

resource "aws_security_group" "this_security_group" {
  for_each    = toset(var.this_SG_name)
  name        = each.key
  description = "Managed by Terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

variable "this_SG_name" {
  type    = list(string)
  default = ["SG1", "SG2", "SG3"]
}


// With For Loop
/* 
Use of for loop in terraform
for loop is used to iterate over a list of values and create a resource for each value in the list.


 */
output "security_group_id" {

  value = [for sg in aws_security_group.this_security_group : sg.id]
}


// Practicing provisioners in terraform
/* what is provisioners?
Provisioners in Terraform enable you to do post-deployment configuration. 
This could be anything from running a shell script, to installing a package, 
to bootstrapping a configuration management tool such as Chef or Puppet. 

Provisioners are a last resort, and should only be used when no other solution will do.

There are two types of provisioners in Terraform: local-exec and remote-exec.

local-exec provisioner
The local-exec provisioner allows you to run a command on the machine running Terraform.

remote-exec provisioner
The remote-exec provisioner allows you to run a command on a remote resource.

*/

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
   
}

// example of remote-exec provisioner

resource "aws_instance" "example2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "Ohio_MG"
  vpc_security_group_ids = ["sg-0050a2ffd29d4f6e1"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/mnt/c/Users/Mayur/Downloads/Ohio_MG1.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx"
    ]
  }
}