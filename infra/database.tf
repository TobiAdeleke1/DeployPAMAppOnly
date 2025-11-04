locals {

  db_env = {
    DB_NAME     = var.docker_db_name
    DB_USER     = var.docker_db_user
    DB_PASSWORD = var.docker_db_password
    DB_HOST     = var.docker_db_host
    DB_PORT     = var.docker_db_port
  }
  
  final_env = merge(var.compose_env, local.db_env)
  env_file = join("\n", [for k, v in local.final_env : "${k}=${v}"])
}

# Bundle ./app and upload -> build/run on droplet
data "archive_file" "app_tar" {
  type        = "tar.gz"
  source_dir  = "${path.module}/../app"
  output_path = "${path.module}/../app.tar.gz"
}

resource "null_resource" "deploy_app" {
  depends_on = [digitalocean_droplet.web]

  triggers = { app_md5 = data.archive_file.app_tar.output_md5 }

  connection {
    type        = "ssh"
    host        = digitalocean_droplet.web.ipv4_address
    user        = "root"
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = data.archive_file.app_tar.output_path
    destination = "/opt/app/app.tar.gz"
  }

  provisioner "file" {
    content     = local.env_file
    destination = "/opt/app/.env"
  }

  provisioner "remote-exec" {
    inline = [
      "cd  /opt/app",
      "tar -xzf app.tar.gz",
      "if [ -d app ]; then mv app/* .; rmdir app; fi",
      "docker compose pull || true",
      "docker compose build",
      "docker compose up -d",
      "docker system prune -f"
    ]
  }
}