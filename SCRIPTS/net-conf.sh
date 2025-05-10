#!/usr/bin/env bash

# first check if the script is run as root
# if not, request sudo password and restart the script

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please enter your password to continue."
    exec sudo "$0" "$@"
fi

# Kill any existing network manager processes like iwd, systemd-networkd, systemd-resolvd and disable them
killall -9 iwd
killall -9 systemd-networkd
killall -9 systemd-resolved
# killall -9 systemd-socket

systemctl disable iwd.service
systemctl disable systemd-networkd.service
systemctl disable systemd-resolved.service
# systemctl disable systemd-socket-activate.service
systemctl stop iwd.service
systemctl stop systemd-networkd.service
systemctl stop systemd-resolved.service

# Check if the network manager is already enabled
if systemctl is-active --quiet NetworkManager.service; then
    echo "NetworkManager is already enabled."
else
    # Enable and start the network manager
    systemctl enable NetworkManager.service
    systemctl start NetworkManager.service
    echo "NetworkManager has been enabled and started."
fi
