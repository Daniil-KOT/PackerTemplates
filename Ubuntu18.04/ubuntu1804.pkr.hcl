packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "boot_wait"{
    type    = string
    default = "2s"
}

variable "communicator"{
    type    = string
    default = "ssh"
}

variable "guest_os_type"{
    type    = string
    default = "Ubuntu_64"
}

variable "vm_name"{
    type    = string
    default = "packer-ubuntu18.04" 
}

variable "headless"{
    type    = bool
    default = false
}

variable "iso_checksum"{
    type    = string
    default = "sha256:f730be589aa1ba923ebe6eca573fa66d09ba14c4c104da2c329df652d42aff11"
}

variable "iso_file"{
    type    = string
    default = "ubuntu-18.04.6-desktop-amd64.iso"
}

variable "iso_path_internal"{
    type    = string
    default = "file://E:/AladdinR.D/Packer/isos"
}

variable "iso_path_external"{
    type    = string
    default = "http://releases.ubuntu.com/18.04/"
}

variable "ssh_username"{
    type    = string
    default = "testuser"
}

variable "ssh_password"{
    type    = string
    default = "testpass"
}

variable "ssh_handshake_attempts"{
    type    = string
    default = "200"
}

variable "ssh_timeout"{
    type    = string
    default = "40m"
}

variable "preseed_directory"{
    type    = string
    default = "http"
}

variable "preseed_file"{
    type = string
    default = "preseed.cfg"
}

variable "disk_size"{
    type    = number
    default = 8192
}

source "virtualbox-iso" "test"{

  boot_command = [
        " <wait>",
        " <wait>",
        " <wait>",
        " <wait>",
        " <wait>",
        "<esc><esc><enter><wait><wait><wait>",
        "/casper/vmlinuz noapic ",
        "initrd=/casper/initrd ",
        "auto=true ",
        "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ",
        "language=en ",
        # if coutry=RU the installation stops at the choose locale screen
        # despite the fact that it's defined down below
        "country=US ",
        "locale=en_US.UTF-8 ",
        "hostname=${var.vm_name} ",
        "domain= ",
        "interface=auto ",
        "console-setup/ask_detect=false ",
        "keyboard-configuration/layoutcode=us ",
        "---<enter>"
  ]

  boot_wait = var.boot_wait
  communicator = var.communicator
  guest_os_type = var.guest_os_type
  vm_name = var.vm_name

  headless = var.headless

  iso_checksum = var.iso_checksum 
  iso_urls = [
    "${var.iso_path_internal}/${var.iso_file}",
    "${var.iso_path_external}/${var.iso_file}"
  ]

  http_directory = var.preseed_directory
 
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_handshake_attempts = var.ssh_handshake_attempts
  ssh_wait_timeout = var.ssh_timeout

  vboxmanage = [["modifyvm", "{{ .Name }}", "--memory", "1024"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  
  disk_size = var.disk_size
  
  shutdown_command = "echo 'testpass' | sudo -S shutdown -P now"
}

build{

  name = "test"

  sources = ["sources.virtualbox-iso.test"]

  provisioner "shell" {
      inline = ["ls /"]
    }
}