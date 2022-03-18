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

variable "host_port_max"{
    type    = string
    default = "8888"
}

variable "host_port_min"{
    type    = string
    default = "4444"
}

variable "http_port_max"{
    type    = string
    default = "9000"
}

variable "http_port_min"{
    type    = string
    default = "8000"
}

variable "iso_checksum"{
    type    = string
    default = "sha256:6c647b1ab4318e8c560d5748f908e108be654bad1e165f7cf4f3c1fc43995934"
}

variable "iso_file"{
    type    = string
    default = "ubuntu-18.04.6-live-server-amd64.iso"
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
    default = "test"
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
        "<esc><wait>",
        "<f6><wait>",
        "<esc><wait>",
        "<bs><bs><bs><bs><wait>",
        "ksdevice=ens0 ",
        "locale=en_US.UTF-8 ",
        "keyboard-configuration/layoutcode=us",
        "hostname=${var.vm_name} ",
        "interface=ens0 ",
        #"auto=true ",
        "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
        "console-setup/ask_detect=false ",
        "---<enter>"
  ]

  boot_wait = var.boot_wait
  communicator = var.communicator
  guest_os_type = var.guest_os_type
  vm_name = var.vm_name

  headless = var.headless

  host_port_max = var.host_port_max
  host_port_min = var.host_port_min

  #http_port_max = var.http_port_max
  #http_port_min = var.http_port_min

  iso_checksum = var.iso_checksum 
  iso_urls = [
    "${var.iso_path_internal}/${var.iso_file}",
    "${var.iso_path_external}/${var.iso_file}"
  ]

  http_directory = var.preseed_directory
  #http_content         = { "/preseed.cfg" = templatefile(var.preseed_file, { var = var }) }
  
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_handshake_attempts = var.ssh_handshake_attempts
  ssh_wait_timeout = var.ssh_timeout

  vboxmanage = [["modifyvm", "{{ .Name }}", "--memory", "1024"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  
  disk_size = var.disk_size
  
  shutdown_command = "echo 'test' | sudo -S shutdown -P now"
}

build{

  name = "test"

  sources = ["sources.virtualbox-iso.test"]

  provisioner "shell" {
      inline = ["ls /"]
    }
}