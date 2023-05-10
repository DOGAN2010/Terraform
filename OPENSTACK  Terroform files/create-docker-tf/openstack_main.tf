terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
  }
}

provider "openstack" {
  # Configuration options
  user_name = "${var.openstack_user_name}"
  tenant_name = "${var.openstack_tenant_name}"
  password  = "${var.openstack_password}"
  auth_url  = "${var.openstack_auth_url}"
  domain_name = "Default"
}
# Upload public key
resource "openstack_compute_keypair_v2" "cloud.key" {
  name = "cloud.key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
  }
resource "openstack_compute_instance_v2" "blc" {
  name = "ubuntu"
  image_name = "${var.image}"
  availability_zone = "${var.availability_zone}"
  flavor_name = "${var.flavor}"
  key_pair = "cloud.key"
  security_groups = ["blc-SG"]
  network {
    name = "${var.network}"
  }
  user_data = "${file("user_data.sh")}"
}
# Create a web security group
resource "openstack_compute_secgroup_v2" "blc-SG" {
  name        = "blc-SG"
  description = "Security Group Description"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
