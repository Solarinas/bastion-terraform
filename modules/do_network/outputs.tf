output "vpc_uuid" {
  value = digitalocean_vpc.Sol.id
}

output "vpc_ip_range" {
  value = digitalocean_vpc.Sol.ip_range
}
