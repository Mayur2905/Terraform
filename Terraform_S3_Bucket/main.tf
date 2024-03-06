# Static Website Hosting using S3 Bucket by Terraform
// This is the main file of the terraform code. This file is used to create an S3 bucket and upload an object to the bucket. 
// The object is a simple HTML file. The file also contains the code to set the bucket as a static website. 
// The code also sets the bucket ownership to the bucket owner. The code also sets the public access block to the bucket. 
// The code also sets the bucket ACL to public-read. The code also sets the object ACL to public-read. 
// The code also sets the object content type to text/html. The code also sets the object etag to the md5 hash of the file

// Author: Mayur Gaikwad

# provider "aws" {
#   region     = "Your Region"
#   access_key = "Your Access Key"
#   secret_key = "Your Secret Key"

# }


resource "aws_s3_bucket" "this_bucket" {
  bucket = "mys3buncketmg"
  # acl = "public-read"
  tags = {
    Name = "A Bucket By Mayur"
    Env = "Dev"
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

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "this_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this_ownership,
    aws_s3_bucket_public_access_block.this_public_block,
    ]  

    bucket = aws_s3_bucket.this_bucket.id
    acl = "public-read"
}

resource "aws_s3_object" "this_object" {
  bucket = aws_s3_bucket.this_bucket.bucket
  key = "index.html"
  source = "/mnt/d/new.html"
  content_type = "text/html"
  etag = filemd5("/mnt/d/new.html")
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "this_web" {
  bucket = aws_s3_bucket.this_bucket.id
  index_document {
    suffix = "index.html"
  }

} 