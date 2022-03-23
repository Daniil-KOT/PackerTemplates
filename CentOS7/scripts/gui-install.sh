#!/bin/bash -eux

echo '---------- [START] GNOME Desktop installation ----------'
yum groups install "GNOME Desktop" -y
echo '---------- [FINISH] GNOME Desktop installation ----------'

echo '---------- [START] Setting GNOME as default ----------'
echo 'exec gnome-session' >> ~/.xinitrc
echo '---------- [FINISH] Setting GNOME as default ----------'

echo '---------- [START] Setting graphical env as default ----------'
systemctl set-default graphical.target
echo '---------- [FINISH] Setting graphical env as default ----------'