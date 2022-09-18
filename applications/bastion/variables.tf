variable region {
  default = "tor1"
}

variable size {
  default = "s-1vcpu-1gb"
}

variable nat_gateway_image {
  default = "rockylinux-9-x64"
}

variable bastion_init {
  default = "./applications/bastion/bastion.tftpl"
}

variable nat_gateway_init {
  default = "./applications/bastion/gateway.tftpl"
}

# Importaed variables
variable prvt_key {}

variable pub_key {}

variable vpc_id {}

variable vpc_ip_range {}
