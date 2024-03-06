# variable "aws_instance_type" {
#   type    = string
#   default = "t2.micro"
# }

# variable "aws_key" {
#   type    = string
#   default = "california"
# }

# variable "aws_volume_size" {
#   type    = number
#   default = 10

# }

# variable "user_data_base64" {
#   type    = bool
#   default = false
# }

# variable "port_no" {
#   type    = list(any)
#   default = [22, 80, 8080, 443, 3306]
# }

# variable "tags" {
#   type = map(any)
#   default = {
#     insatance_tag = "Jenkins_Master"
#     security_tag  = "Mg_Security_Group"
#   }
# }