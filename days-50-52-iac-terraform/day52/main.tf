terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_container" "web" {
  name  = "tf-nginx-day52"
  image = "nginx:latest"
  ports {
    internal = 80
    external = var.host_port
  }
}
