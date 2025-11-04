output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}

output "database_url" {
  value     = {
    type = "docker"
    host = var.docker_db_host
    port = var.docker_db_port
  }
}