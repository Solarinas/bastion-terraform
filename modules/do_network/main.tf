terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

locals {
  vpc_name = "sol-vpc-${terraform.workspace}"
}

# Create the VPC
resource "digitalocean_vpc" "Sol" {
  name = local.vpc_name
  region = var.region
  ip_range = "10.10.1.0/24"
}

# Create the DigitalOcean Tags
resource "digitalocean_tag" "bastion_tag" {
  name = "bastion"
}

resource "digitalocean_tag" "nat_gateway_tag" {
  name = "nat_gateway"
}

# Create Digitalocean firewall rule
resource "digitalocean_firewall" "bastion" {
  name = "Bastion"
  depends_on = [
    digitalocean_tag.bastion_tag
  ]
  tags = [ "bastion" ]

  # allow ssh from any connection
  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  # allow outbound tcp connections
  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "nat_gateway" {
  name = "NAT-Gateway"
  depends_on = [
    digitalocean_tag.nat_gateway_tag
  ]
  tags = [ "nat_gateway" ]

  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    source_tags = [ "bastion" ]
  }

  # allow outbound connections
  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = [ "0.0.0.0/0", "::/0" ]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = [ "0.0.0.0/0", "::/0" ]
  }
}
