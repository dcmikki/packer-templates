
variable "password" {
  type    = string
  default = "vagrant"
}

variable "username" {
  type    = string
  default = "vagrant"
}

variable "version" {
  type    = string
  default = "2009"
}

variable "vm_name" {
  type    = string
  default = "centos7.9"
}

source "vmware-iso" "centos7" {
  boot_command     = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait        = "20s"
  cpus             = 2
  guest_os_type    = "centos-64"
  headless         = true
  http_directory   = "http"
  iso_checksum     = "file:http://mirror.de.leaseweb.net/centos/7/isos/x86_64/sha256sum.txt"
  iso_urls         = ["iso/CentOS-7-x86_64-Minimal-${var.version}.iso", "http://mirror.de.leaseweb.net/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-${var.version}.iso"]
  memory           = 2048
  output_directory = "output-centos"
  shutdown_command = "echo '${var.password}' | sudo -S /sbin/halt -h -p"
  ssh_password     = "${var.password}"
  ssh_port         = 22
  ssh_timeout      = "20m"
  ssh_username     = "${var.username}"
  vm_name          = "${var.vm_name}.box"
}

build {
  sources = ["source.vmware-iso.centos7"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    scripts         = [
      "scripts/install_epel-release.sh",
      "scripts/configure_vagrant_public_key.sh",
      "scripts/install_vmware_tools.sh",
      "scripts/cleanup.sh",
      "scripts/skrink_box.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    output              = "box/{{ .Provider }}/${var.vm_name}.${var.version}.box"
  }
}

packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.3"
      source = "github.com/hashicorp/vmware"
    }
  }
}