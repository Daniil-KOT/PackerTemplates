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
    default = "packer-centos8" 
}

variable "headless"{
    type    = bool
    default = false
}

variable "iso_checksum"{
    type    = string
    default = "sha256:cc20b0e3cba1f3f6a9a7a720a946f4a3fdf5e06fb0bbe5f643879550ff72030f"
}

variable "iso_file"{
    type    = string
    default = "CentOS-Stream-8-x86_64-20220310-boot.iso"
}

variable "iso_path_internal"{
    type    = string
    default = "file://E:/AladdinR.D/Packer/isos"
}

variable "iso_path_external"{
    type    = string
    default = "https://mirror.yandex.ru/centos/8/"
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
    default = "120m"
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
    default = 20480
}

variable "output_dir"{
    type    = string
    default = "E:/AladdinR.D/Packer/output-test-centos8/"
}

source "vmware-iso" "test"{

    boot_command = [
        "<wait>",
        "<wait>",
        "<tab><wait>",
        "<bs><bs><bs><bs><bs>",
        "graphical<wait> ", 
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
  
    output_directory = var.output_dir

    shutdown_command = "echo 'testpass' | sudo shutdown -h 0"
}

build{

    name = "test"

    sources = ["sources.vmware-iso.test"]

    provisioner "shell" {
        execute_command = "echo 'testpass' | sudo -E -S bash '{{.Path}}'"
        scripts = [
            "./scripts/yum-update.sh",
            "./scripts/gui-install.sh"
            ]
        expect_disconnect = true
    }
}