
variable "secgr-dynamic-ports" {
  default = [22,8081] # 8081 portun biri her yöne biriside jenkins server!in securty grubuna bağlanaçak.
}

variable "instance-type" {
  default = "t3a.micro"
  sensitive = true
}
variable "instance-ami" {
  default = "ami-00874d747dde814fa" 
}
variable "key_name" {
  default = "dogankrc"
  sensitive = true
}
