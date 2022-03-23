#!/bin/bash -eux

echo '---------- [START] dnf update ----------'
dnf -y makecache
dnf -y check-update
dnf -y upgrade
echo '---------- [FINISH] dnf update ----------'