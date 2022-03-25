#!/bin/bash -eux

echo '---------- [START] apt update ----------'
apt-get -y update
apt-get -y dist-upgrade --force-yes
echo '---------- [FINISH] apt update ----------'

reboot