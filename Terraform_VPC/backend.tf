terraform {
  backend "s3" {
    bucket = "demo.techwithmayur.cloud"
    key = "terraform.tfstate"
    dynamodb_table = "dynamodb"
    region = "us-west-1"
    profile = "configs"
    shared_credentials_files = [ "/home/mayur/.aws/credentials" ]
  }

}