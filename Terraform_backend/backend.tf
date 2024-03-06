# Create a S3 bucket for Terraform state

resource "aws_s3_bucket" "this_bucket" {
  bucket = "state.techwithmayur.cloud"
}

resource "aws_s3_bucket_versioning" "this_versioning" {
  bucket = aws_s3_bucket.this_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this_encryption" {
  bucket = aws_s3_bucket.this_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
  
}



# Cretaing a DynamoDB table for state locking

resource "aws_dynamodb_table" "this_table" {
  name = "terraform_state_lock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}