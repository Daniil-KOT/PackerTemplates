# Packer Templates

## Что такое Packer Templates? / What is Packer Templates?

##### РУССКИЙ:

**Packer Templates** это набор конфигурационных файлов, которые могут быть использованы, чтобы развернуть разные дистрибутивы Linux в виртуальной машине, используя [Packer](https://www.packer.io/).
Представленные в репозитории конфигурационные файлы позволят Вам развернуть образы в рамках VMWare Workstation.

##### ENGLISH:

**Packer Templates** is a set of configuration files used to build different Linux VM images using [Packer](https://www.packer.io/).
These Packer configuration files allow you to build images for VMWare Workstation.

## Необходимое ПО / Required Software

- [Packer](https://www.packer.io/)
  - <https://learn.hashicorp.com/tutorials/packer/get-started-install-cli>
- [VMware Workstation](https://www.vmware.com/products/workstation-pro.html)


## Как использовать Packer / How to use Packer

##### РУССКИЙ:

Чтобы начать автоматическую установку необходимо перейти в директорию дистрибутива, который хотите развернуть и выполнить команду `packer build linuxversion.pkr.hcl`, например:

```cmd
cd c:\packerstands\CentOS7
packer build centos7.pkr.hcl
```

##### ENGLISH:

In order to start automated build, first, you should move to the directory of desired Linux version and run the command `packer build linuxversion.pkr.hcl`, for example:

```cmd
cd c:\packerstands\CentOS7
packer build centos7.pkr.hcl
```

## ISO образы / ISO images

##### РУССКИЙ:

Для каждого дистрибутива файлы .iso по умолчанию проверяются сначала локально, однако необходимо указать путь к образу на вашем компьтере в переменной **"iso_path_internal"** в файле **.pkr.hcl**:

```hcl
variable "iso_path_internal"{
    type    = string
    default = "file://<YOUR LOCAL PATH TO ISO FILE>"
}
```

Если файл не был найден на локально, он будет загружен с зеркала указанного в переменной **"iso_path_external"**.
По умолчанию для:
- **Ubuntu**

```hcl
variable "iso_path_external"{
    type    = string
    default = "http://releases.ubuntu.com/<версия дистрибутива>/"
}
```

- **CentOS** *(вы можете сменить зеркало на ближайшее к вам)*

```hcl
variable "iso_path_external"{
    type    = string
    default = "https://mirror.yandex.ru/centos/<версия дистрибутива>/"
}
```

##### ENGLISH:

For each version Packer looks for .iso files locally, however you should declare the path to the .iso file on your computer in the variable **"iso_path_internal"** in **.pkr.hcl** file:
```hcl
variable "iso_path_internal"{
    type    = string
    default = "file://<YOUR LOCAL PATH TO ISO FILE>"
}
```

If the file was not found locally, it will be downloaded from the mirror declared in the variable **"iso_path_external"**.
As a default the path is set:

- **In Ubuntu**
```hcl
variable "iso_path_external"{
    type    = string
    default = "http://releases.ubuntu.com/<version>/"
}
```
- **CentOS** *(notice that you can change the mirror to a closer one for you)*
```hcl
variable "iso_path_external"{
    type    = string
    default = "https://mirror.yandex.ru/centos/<version>/"
}
```

## Прочие настройки / Other Settings

##### РУССКИЙ:

Настройки самой системы можно изменить в конфигурационных файлах:

- **Ubuntu** - preseed.cfg
- **CentOS** - ks.cfg

Обратите внимание, что при изменении данных пользователя, таких как логин и пароль, необходимо также отредактировать следующие переменные в файле **.pkr.hcl**:

- Логин
```hcl
variable "ssh_username"{
    type    = string
    default = "testuser"
}
```
- Пароль
```hcl
variable "ssh_password"{
    type    = string
    default = "testpass"
}
```

В противном случае Packer ***не сможет*** завершить настройку системы.

##### ENGLISH:

You can change settings of the system itself in the configuration files:

- **Ubuntu** - preseed.cfg
- **CentOS** - ks.cfg

Notice that if you change the user data such as username and/or password, you should also edit the following variables in **.pkr.hcl** files:

- Username
```hcl
variable "ssh_username"{
    type    = string
    default = "testuser"
}
```
- Password
```hcl
variable "ssh_password"{
    type    = string
    default = "testpass"
}
```

In other case Packer **won't be able to** finish the system setup.
