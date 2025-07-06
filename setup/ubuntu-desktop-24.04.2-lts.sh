#!/bin/bash
# tweak Ubuntu desktop 24.04.2 LTS

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

# Tweak gnome
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.sound event-sounds false

# Disable unused service, socket
# TODO
systemctl disable bluetooth cups

# rtirq-init priority USB output
# TODO