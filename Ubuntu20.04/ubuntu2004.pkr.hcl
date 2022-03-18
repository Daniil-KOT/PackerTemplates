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
    default = "packer-ubuntu20.04" 
}

variable "headless"{
    type    = bool
    default = false
}

variable "iso_checksum"{
    type    = string
    default = "sha256:28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
}

variable "iso_file"{
    type    = string
    default = "ubuntu-20.04.4-live-server-amd64.iso"
}

variable "iso_path_internal"{
    type    = string
    default = "file://E:/AladdinR.D/Packer/isos"
}

variable "iso_path_external"{
    type    = string
    default = "http://releases.ubuntu.com/20.04/"
}

variable "ssh_username"{
    type    = string
    default = "root"
}

variable "ssh_password"{
    type    = string
    default = "Rootpasswd1"
}

variable "ssh_handshake_attempts"{
    type    = string
    default = "200"
}

variable "ssh_timeout"{
    type    = string
    default = "40m"
}

variable "userdata_directory"{
    type    = string
    default = "http"
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
        "<esc><wait>",
        "<f6><wait>",
        "<esc><wait>",
        "<bs><bs><bs><bs><wait>",
        " autoinstall<wait>",
        " ds=nocloud-net<wait>",
        ";s=http://<wait>{{.HTTPIP}}<wait>:{{.HTTPPort}}/<wait>",
        " ---<wait>",
        "<enter><wait>"
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

  http_directory = var.userdata_directory
  
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_handshake_attempts = var.ssh_handshake_attempts
  ssh_wait_timeout = var.ssh_timeout

  vboxmanage = [["modifyvm", "{{ .Name }}", "--memory", "1024"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  
  disk_size = var.disk_size
  
  shutdown_command = "echo 'admin' | sudo -S shutdown -P now"
}

build{

  name = "test"

  sources = ["sources.virtualbox-iso.test"]

  provisioner "shell" {
      inline = ["ls /"]
    }
}