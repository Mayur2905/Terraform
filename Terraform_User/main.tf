// Create a user and attach a policy to it and add it to a group 

// Author: Mayur Gaikwad


provider "aws" {
  region     = ""
  access_key = ""
  secret_key = ""

}

resource "aws_iam_user" "this_user" {
  name = "TF-MG"
  path = "/"
  tags = {
    name = "by_mg"
  }
}
resource "aws_iam_access_key" "this_key" {
  user = aws_iam_user.this_user.name

}

resource "aws_iam_user_policy" "this_policy" {
  name = "this_policy"
  user = aws_iam_user.this_user.name

   policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group" "this_group" {
  name = "this_group"
  path = "/"

}
resource "aws_iam_group_membership" "this_membership" {
  name  = "this_membership"
  users = [aws_iam_user.this_user.name]
  group = aws_iam_group.this_group.name
}
