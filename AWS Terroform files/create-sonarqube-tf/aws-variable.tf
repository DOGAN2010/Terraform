
variable "secgr-dynamic-ports" {
  default = [22,80] # 80 portun biri her yöne biriside jenkins server!in securty grubuna bağlanaçak.
}

variable "instance-type" {
  default = "t3a.medium"
  sensitive = true
}
variable "instance-ami" {
  default = "ami-00874d747dde814fa" 
}
variable "key_name" {
  default = "dogankrc"
  sensitive = true
}
