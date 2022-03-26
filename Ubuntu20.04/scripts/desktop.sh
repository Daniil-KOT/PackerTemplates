#!/bin/bash -eux

echo '---------- [START] Ubuntu Desktop installation ----------'
apt-get install -y ubuntu-desktop
echo '---------- [FINISH] Ubuntu Desktop installation ----------'

echo '---------- [START] Setting graphical env as default ----------'
systemctl set-default graphical.target
echo '---------- [FINISH] Setting graphical env as default ----------'