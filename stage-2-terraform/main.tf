provider "virtualbox" {}

resource "virtualbox_vm" "ansible_vm" {
  name = "AnsibleVM"
  image = "ubuntu/focal64"
  cpus = 2
  memory = 2048
}

output "vm_ip" {
  value = "192.168.56.101"
}
