// This is the main file for the Terraform Route53 project
// This file is used to create a Route53 hosted zone and a record set in the hosted zone
// The file also contains the code to create an S3 bucket and set the bucket as a static website

// Author: Mayur Gaikwad


provider "aws" {
  region     = "us-west-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"

}

resource "aws_instance" "this_instance" {
  ami               = "ami-07619059e86eaaaa2"
  instance_type     = "t2.micro"
  availability_zone = "us-west-1c"
  key_name          = "california"
  tags = {
    Name = "Instance_by_MG"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Deployed via Terraform</h1>" > /var/www/html/index.html
              EOF
}

resource "aws_s3_bucket" "this_bucket" {
  bucket = "s3.techwithmayur.cloud"
  # acl = "public-read"
  tags = {
    Name = "A Bucket By Mayur"
    Env  = "Dev"
  }

}


resource "aws_s3_bucket_ownership_controls" "this_ownership" {
  bucket = aws_s3_bucket.this_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this_public_block" {
  bucket = aws_s3_bucket.this_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "this_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this_ownership,
    aws_s3_bucket_public_access_block.this_public_block,
  ]

  bucket = aws_s3_bucket.this_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "this_object" {
  bucket       = aws_s3_bucket.this_bucket.bucket
  key          = "index.html"
  source       = "/mnt/d/new.html"
  content_type = "text/html"
  etag         = filemd5("/mnt/d/new.html")
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "this_web" {
  bucket = aws_s3_bucket.this_bucket.id
  index_document {
    suffix = "index.html"
  }

}

resource "aws_route53_zone" "this_zone" {
  name = "techwithmayur.cloud"
}

resource "aws_route53_record" "this_record" {
  zone_id = aws_route53_zone.this_zone.zone_id
  name    = "techwithmayur.cloud"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.this_instance.public_ip]
}

resource "aws_route53_record" "this_record2" {
  zone_id = aws_route53_zone.this_zone.zone_id
  name    = "www.techwithmayur.cloud"
  type    = "CNAME"
  ttl     = "300"
  records = ["techwithmayur.cloud"]
}

resource "aws_route53_record" "this_s3_web" {
  zone_id = aws_route53_zone.this_zone.zone_id
  name    = "s3.techwithmayur.cloud"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_s3_bucket.this_bucket.bucket_regional_domain_name]
}
