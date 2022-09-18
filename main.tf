terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "dmurray" {
  name = "dmurray"
}

module "do_network" {
  source = "./modules/do_network"
}

module "bastion" {
  source = "./applications/bastion"

  vpc_id = module.do_network.vpc_uuid
  vpc_ip_range = module.do_network.vpc_ip_range

  prvt_key = var.prvt_key
  pub_key = var.pub_key
}
