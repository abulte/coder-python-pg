
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22"
    }
  }
}

variable "python_version" {
  description = "What python version would you like to use for your workspace?"
  default     = "latest"
}

variable "postgres_version" {
  description = "What postgres version would you like to use for your workspace?"
  default     = "latest"
}

# this installs coder with a python container
module "coder_python" {
  source = "github.com/abulte/coder-python"
  private_docker_network = true
  python_version = var.python_version
  workspace_envs = [
    "DATABASE_URL=postgresql://postgres:postgres@${docker_container.postgres.name}:5432"
  ]
}

resource "docker_volume" "db_volume" {
  name = "coder-${module.coder_python.coder_workspace_data.id}-db"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  dynamic "labels" {
    for_each = module.coder_python.common_labels
    content {
      label = labels.value.label
      value = labels.value.value
    }
  }
}

resource "docker_image" "postgres" {
  name = "postgres:${var.postgres_version}"
}

resource "docker_container" "postgres" {
  # Uses lower() to avoid Docker restriction on container names.
  # TODO: move prefix into a local and output in parent module
  name = "coder-${module.coder_python.coder_workspace_data.owner}-${lower(module.coder_python.coder_workspace_data.name)}-db"
  image  = docker_image.postgres.image_id
  env = [
    "POSTGRES_PASSWORD=postgres",
    "POSTGRES_USER=postgres",
    "POSTGRES_DB=postgres"
  ]
  volumes {
    container_path = "/var/lib/postgresql/data/"
    volume_name    = docker_volume.db_volume.name
    read_only      = false
  }
  # attach to coder_python private network
  networks_advanced {
    name = module.coder_python.docker_network_name
  }
}
