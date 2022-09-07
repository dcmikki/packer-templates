
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

source "virtualbox-iso" "centos7" {
  boot_command            = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  boot_wait               = "2s"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "RedHat_64"
  headless                = true
  http_directory          = "http"
  iso_checksum            = "file:http://mirror.de.leaseweb.net/centos/7/isos/x86_64/sha256sum.txt"
  iso_target_path         = "iso"
  iso_urls                = [
    "iso/CentOS-7-x86_64-Minimal-${var.version}.iso",
    "http://mirror.de.leaseweb.net/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-${var.version}.iso"
  ]
  output_directory        = "output-centos"
  post_shutdown_delay     = "15s"
  shutdown_command        = "echo '${var.password}' | sudo -S /sbin/halt -h -p"
  ssh_password            = "${var.password}"
  ssh_timeout             = "20m"
  ssh_username            = "${var.username}"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "2048"], ["modifyvm", "{{ .Name }}", "--cpus", "2"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}.box"
}

build {
  sources = ["source.virtualbox-iso.centos7"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    scripts         = [
      "scripts/install_epel-release.sh", 
      "scripts/configure_vagrant_public_key.sh",
      "scripts/install_guest_additions.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    compression_level   = 9
    output              = "box/{{ .Provider }}/${var.vm_name}.${var.version}.box"
  }
}
