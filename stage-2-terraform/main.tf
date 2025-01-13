# Define providers
provider "virtualbox" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# VirtualBox VM resource
resource "virtualbox_vm" "ansible_vm" {
  name  = "ansible-vm"
  image = "ubuntu/focal64" # Ubuntu 20.04 base image

  # VM specifications
  cpus   = 2
  memory = 2048

  # Networking
  network_adapter {
    type           = "hostonly"
    host_interface = "vboxnet0" # Ensure this matches your VirtualBox host-only network
  }
}

# Docker network
resource "docker_network" "app_net" {
  name = "app-net"
}

# Docker volume
resource "docker_volume" "mongo_data" {
  name = "app-mongo-data"
}

# Backend container
resource "docker_image" "backend_image" {
  name = "kamandembugua/yolo-client:v1.0.0"
}

resource "docker_container" "backend_container" {
  name  = "yolo-backend"
  image = docker_image.backend_image.latest

  # Networking
  networks_advanced {
    name = docker_network.app_net.name
  }

  # Port mapping
  ports {
    internal = 5000
    external = 5000
  }

  # Volume mapping
  mounts {
    target = "/data/db"
    source = docker_volume.mongo_data.name
    type   = "volume"
  }

  # Command to start the application
  command = "npm start"
}

# Output for Ansible inventory
output "vm_ip" {
  value       = virtualbox_vm.ansible_vm.private_ip
  description = "The private IP address of the VM"
}

# Provisioning with local-exec for Ansible
provisioner "local-exec" {
  command = <<EOT
  echo "[all]
  ${virtualbox_vm.ansible_vm.private_ip} ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key" > ansible/inventory
  ansible-playbook -i ansible/inventory ansible/main.yml
  EOT
}
