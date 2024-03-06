//  Terraform code to create a DB instance in AWS

// Author: Mayur Gaikwad

resource "aws_db_instance" "this_db" {
  allocated_storage = 50
  storage_type      = "gp2"
  engine            = "mysql"
  instance_class    = "db.t2.micro"
  username          = "admin"
  password          = "admin123"
  db_name           = "mydb_instance"
  skip_final_snapshot  = "true"

}


