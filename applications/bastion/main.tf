terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

locals {
  bastion_name = "ssh-bastion-${terraform.workspace}"
  nat_gateway_name = "nat-gateway-${terraform.workspace}"
}

data "digitalocean_ssh_key" "dmurray" {
  name = "dmurray"
}

resource "digitalocean_droplet" "bastion" {
  image = var.nat_gateway_image
  name = local.bastion_name
  region = var.region
  size = var.size
  vpc_uuid = var.vpc_id

  tags = [
    "bastion",
  ]

  ssh_keys = [
    data.digitalocean_ssh_key.dmurray.id
  ]

  user_data = templatefile(var.bastion_init,
    {
      pub_key = file(var.pub_key)
    })
}

resource "digitalocean_droplet" "nat_gateway" {
  image = var.nat_gateway_image
  name = local.nat_gateway_name
  region = var.region
  size = var.size
  vpc_uuid = var.vpc_id

  tags = [
    "nat_gateway"
  ]

  ssh_keys = [
    data.digitalocean_ssh_key.dmurray.id
  ]

  user_data = templatefile(var.nat_gateway_init,
    {
      pub_key = file(var.pub_key)
      vpc_ip_range = var.vpc_ip_range
    })
}
