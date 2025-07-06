#!/bin/bash
# Script to configure Ubuntu desktop 24.04.2 LTS for audio playback.

# Remove current user password login
USERNAME="${SUDO_USER:-$USER}"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopasswd_$USERNAME
sudo passwd -d $USERNAME

# Change ssh config `/etc/ssh/sshd_config`
# TODO
# PermitRootLogin yes 
# PermitEmptyPasswords yes 

# priority @audio add user to group
# TODO

# Pipewire configuration
# TODO

# Config gnome
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.SessionManager logout-prompt false

# Disable unused/marked service, socket
# update service cloud init cups bluetooth and others
# disable TODO
systemctl disable bluetooth cups

# rtirq-init priority USB output
# TODO