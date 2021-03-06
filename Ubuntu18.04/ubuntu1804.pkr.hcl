packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.3"
      source = "github.com/hashicorp/vmware"
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
    default = "ubuntu64Guest"
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
    default = "sha256:f5cbb8104348f0097a8e513b10173a07dbc6684595e331cb06f93f385d0aecf6"
}

variable "iso_file"{
    type    = string
    default = "ubuntu-18.04.6-server-amd64.iso"
}

variable "iso_path_internal"{
    type    = string
    default = ""
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

variable "output_dir"{
    type    = string
    default = ""
}

source "vmware-iso" "test"{

  boot_command = [
        " <wait>",
        " <wait>",
        " <wait>",
        " <wait>",
        " <wait>",
        "<esc><esc><enter><wait><wait><wait>",
        "install initrd=/install/initrd.gz ",
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

  vmx_data = {
        memsize = "1024",
        numvcpus = "1"
    }
  
  disk_size = var.disk_size

  output_directory = var.output_dir
  
  shutdown_command = "echo 'testpass' | sudo -S shutdown -P now"
}

build{

  name = "test"

  sources = ["sources.vmware-iso.test"]

  provisioner "shell" {
        execute_command = "echo 'testpass' | sudo -E -S bash '{{.Path}}'"
        scripts = [
            "./scripts/apt-upgrade.sh",
            "./scripts/desktop.sh"
        ]
        expect_disconnect = true
    }
}