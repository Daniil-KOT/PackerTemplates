packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.3"
      source = "github.com/hashicorp/vmware"
    }
  }
}

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
    default = "4s"
}

variable "communicator"{
    type    = string
    default = "ssh"
}

variable "guest_os_type"{
    type    = string
    default = "centos-64"
}

variable "vm_name"{
    type    = string
    default = "packer-centos7" 
}

variable "headless"{
    type    = bool
    default = false
}

variable "iso_checksum"{
    type    = string
    default = "sha256:07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"
}

variable "iso_file"{
    type    = string
    default = "CentOS-7-x86_64-Minimal-2009.iso"
}

variable "iso_path_internal"{
    type    = string
    default = "file://E:/AladdinR.D/Packer/isos"
}

variable "iso_path_external"{
    type    = string
    default = "http://mirror.truenetwork.ru/centos/7.9.2009/"
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

variable "ks_directory"{
    type    = string
    default = "http"
}

variable "ks_file"{
    type = string
    default = "ks.cfg"
}

variable "disk_size"{
    type    = number
    default = 8192
}

source "vmware-iso" "test"{

    boot_command = [
        "<wait>",
        "<wait>",
        "<tab><wait>",
        "<bs><bs><bs><bs><bs>",
        "text<wait> ", 
        "ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.ks_file}<enter><wait>"
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

    http_directory = var.ks_directory
 
    ssh_username = var.ssh_username
    ssh_password = var.ssh_password
    ssh_handshake_attempts = var.ssh_handshake_attempts
    ssh_wait_timeout = var.ssh_timeout

    vmx_data = {
        memsize = "1024",
        numvcpus = "1"
    }

    disk_size = var.disk_size
  
    shutdown_command = "echo 'testpass' | sudo -S /sbin/halt -h -p"
}

build{

    name = "test"

    sources = ["sources.vmware-iso.test"]

    provisioner "shell" {
        inline = ["ls /"]
    }
}