terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx_webserver" {
  name = var.image_name
}

resource "docker_container" "wcloudv1" {
    image = docker_image.nginx_webserver.image_id
    name  = "webserver"
    
    ports {
            ip = "100.74.26.7"
            internal = 8080
            external = var.external_port
        }

    tmpfs = {
        "/var/cache/nginx" = ""
        "/run" = ""
        "/tmp" = ""
        
    }

    security_opts = [ "no-new-privileges:true" ]

    read_only = true  
}