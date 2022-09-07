
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
  default = "centos7-packer"
}

source "qemu" "centos7" {
  boot_command     = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait        = "2s"
  cpus             = 4
  headless         = true
  http_directory   = "http"
  iso_checksum     = "file:http://mirror.de.leaseweb.net/centos/7/isos/x86_64/sha256sum.txt"
  iso_target_path  = "iso"
  iso_urls         = ["iso/CentOS-7-x86_64-Minimal-${var.version}.iso", "http://mirror.de.leaseweb.net/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-${var.version}.iso"]
  memory           = "4096"
  output_directory = "output-centos"
  shutdown_command = "echo '${var.password}' | sudo -S /sbin/halt -h -p"
  ssh_password     = "${var.password}"
  ssh_timeout      = "20m"
  ssh_username     = "${var.username}"
  vm_name          = "${var.vm_name}.qcow2"
}

build {
  sources = ["source.qemu.centos7"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    script          = "scripts/configure_vagrant_public_key.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    output              = "box/{{.Provider}}/${var.vm_name}-${var.version}.box"
  }
}
