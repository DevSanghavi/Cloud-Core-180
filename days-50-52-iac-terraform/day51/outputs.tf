output "container_name" {
  description = "Name of the created container"
  value       = docker_container.web.name
}

output "host_port" {
  description = "Host port mapped to Nginx"
  value       = docker_container.web.ports[0].external
}

output "image_id" {
  description = "Image ID used by the container"
  value       = docker_image.nginx.image_id
}
