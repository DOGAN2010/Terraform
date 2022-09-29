terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.32.0"
    }
  }
  backend "s3" {
    bucket = "tf-remote-s3-bucket-dogan"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}
locals {
  mytag = "dogan-local-name"
}
data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10*"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = data.aws_ami.tf_ami.id
  instance_type = var.ec2-type
  key_name      = var.key_name
  tags = {
    Name = "${local.mytag}-this is from my-ami"
  }
}
resource "aws_s3_bucket" "tf-s3-count" {
  bucket = "${local.mytag}-${count.index}"
  count = var.num_of_buckets
}
# resource "aws_s3_bucket" "tf-s3" {
#   bucket = "${var.s3_bucket_name}-${count.index}"

#   # count = var.num_of_buckets
#   count = var.num_of_buckets != 0 ? var.num_of_buckets : 3
# }
resource "aws_iam_user" "new_users" {
  for_each = toset(var.users)
  name = each.value
}

# resource "aws_s3_bucket" "tf-s3-for_each" {
#   # bucket = "var.s3_bucket_name.${count.index}"
#   # count = var.num_of_buckets
#   # count = var.num_of_buckets != 0 ? var.num_of_buckets : 1
#   for_each = toset(var.users)
#   bucket   = "example-tf-s3-bucket-${each.value}"
#   depends_on = [
#     aws_iam_user.new_users
#   ]
# }

