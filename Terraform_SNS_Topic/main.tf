// Create a SNS Topic and Subscription

// Author: Mayur Gaikwad

provider "aws" {
  region     = "us-west-1"
  access_key = "AKIAQBWAF7TZHF7IFLKX"
  secret_key = "BP5pkPzxLHqkRxQlKnECEcPzi7v4HnDsUCYMiCai"

}

# provider "aws" {
#   region     = "Your Region"
#   access_key = "Your Access Key"
#   secret_key = "Your Secret Key"
# }

resource "aws_sns_topic" "this_topic" {
  name = "mysantopic"
  display_name = "my_sns_topic"
}

resource "aws_sns_topic_subscription" "this_sub" {
  protocol = "email"
  topic_arn = aws_sns_topic.this_topic.arn
  endpoint = "mayurgaikwad0101@gmail.com"
}
