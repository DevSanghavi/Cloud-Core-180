output "container_id" {
  description = "The unique tracking ID inside Docker"
  value       = docker_container.web.id
}

output "container_name" {
  description = "The registered runtime name of the asset"
  value       = docker_container.web.name
}
