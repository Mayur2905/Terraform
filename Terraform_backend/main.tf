// Configure the Terraform backend to store the state in an S3 bucket and use DynamoDB for locking.

// Author: Mayur Gaikwad


terraform {
  backend "s3" {
    bucket = "state.techwithmayur.cloud"
    key = "terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "terraform_state_lock"
    encrypt = true
    
  }
}

provider "aws" {
  region = "us-west-2"
  shared_credentials_files = ["/home/mayur/.aws/credentials"]
  profile = "configs"
}

# resource "aws_elastic_beanstalk_application" "this" {
#   name = "techwithmayur"

#   appversion_lifecycle {
#     service_role = "aws-elasticbeanstalk-service-role"
#     max_count = 128
#     delete_source_from_s3 = true
#   }
# }

# // elastic beanstalk environment for apache tomcat 8

# resource "aws_elastic_beanstalk_environment" "this_environment" {
#   name = "techwithmayur"
#     application = aws_elastic_beanstalk_application.this.name
#     solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.10 running Tomcat 8 Java 8"
#     setting {
#         namespace = "aws:autoscaling:launchconfiguration"
#         name = "IamInstanceProfile"
#         value = "aws-elasticbeanstalk-ec2-role"
#     }
#     setting {
#         namespace = "aws:autoscaling:launchconfiguration"
#         name = "InstanceType"
#         value = "t2.micro"
#     }
#     setting {
#         namespace = "aws:autoscaling:asg"
#         name = "MinSize"
#         value = "1"
#     }
#     setting {
#         namespace = "aws:autoscaling:asg"
#         name = "MaxSize"
#         value = "1"
#     }
#     setting {
#         namespace = "aws:elasticbeanstalk:environment"
#         name = "EnvironmentType"
#         value = "SingleInstance"
#     }
#     setting {
#         namespace = "aws:elasticbeanstalk:environment"
#         name = "ServiceRole"
#         value = "aws-elasticbeanstalk-service-role"
#     }
#     setting {
#         namespace = "aws:elasticbeanstalk:environment"
#         name = "LoadBalancerType"
#         value = "application"
#     }
#     setting {
#         namespace = "aws:elasticbeanstalk:environment"
#         name = "HealthCheckURL"
#         value = "/index.jsp"
#     }
# }

# resource "aws_elastic_beanstalk_configuration_template" "tf_template" {
#   name                = "tf-test-template-config"
#   application         = aws_elastic_beanstalk_application.tftest.name
#     solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.10 running Tomcat 8 Java 8"
#     setting {
#         namespace = "aws:autoscaling:launchconfiguration"
#         name = "IamInstanceProfile"
#         value = "aws-elasticbeanstalk-ec2-role"
#     }
# }