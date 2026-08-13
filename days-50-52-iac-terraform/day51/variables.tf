variable "container_name" {
  description = "Name of the Docker container"
  type        = string
  default     = "tf-nginx"
}

variable "image_name" {
  description = "Docker image name and tag"
  type        = string
  default     = "nginx:latest"
}

variable "host_port" {
  description = "Host port mapping for Nginx"
  type        = number
  default     = 8080
}

variable "keep_image" {
  description = "Keep the image locally after destroy"
  type        = bool
  default     = true
}
