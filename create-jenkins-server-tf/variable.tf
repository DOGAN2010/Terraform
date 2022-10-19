//variable "aws_secret_key" {}
//variable "aws_access_key" {}
variable "region" {
  default = "us-east-1"
}
variable "mykey" {
  default = "firstkey"
}
variable "tags" {
  default = "jenkins-server"
}
variable "myami" {
  description = "amazon linux 2 ami"
  default = "ami-05ff5eaef6149df49"
}
variable "instancetype" {
  default = "t3a.medium"
}

variable "secgrname" {
  default = "jenkins-server-sec-gr"
}