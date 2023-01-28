
variable "secgr-dynamic-ports" {
  default = [22,80,443]
}

variable "instance-type" {
  default = "t2.micro"
  sensitive = true
}
variable "instance-ami" {
  default = "ami-00874d747dde814fa" 
}
variable "key_name" {
  default = "dogankrc"
  sensitive = true
}
