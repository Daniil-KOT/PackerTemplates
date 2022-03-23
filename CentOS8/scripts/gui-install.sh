#!/bin/bash -eux

echo '---------- [START] GNOME Desktop installation ----------'
dnf groupinstall workstation -y
echo '---------- [FINISH] GNOME Desktop installation ----------'

echo '---------- [START] Setting graphical env as default ----------'
systemctl set-default graphical.target
echo '---------- [FINISH] Setting graphical env as default ----------'