variable "do_token" {
  type      = string
  sensitive = true
}

variable "project_name" { type = string }

variable "ssh_public_key" { type = string }
variable "ssh_private_key" {
  type      = string
  sensitive = true

}

variable "region" {
  type    = string
  default = "lon1"
}

variable "droplet_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "droplet_image" {
  type    = string
  default = "ubuntu-25-04-x64"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
  description = "CIDRs allowed to SSH (22)."
}

variable "app_port" {
  type    = number
  default = 80
}

variable "compose_env" {
  type        = map(string)
  default     = {}
  description = "Extra env vars for .env on the droplet."
}

variable "docker_db_name" { type = string }
variable "docker_db_user" { type = string }

variable "docker_db_password" {
  type      = string
  sensitive = true

}

variable "docker_db_host" {
  type    = string
  default = "db"
}

variable "docker_db_port" {
  type    = string
  default = "5432"
}