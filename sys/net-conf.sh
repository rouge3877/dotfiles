#!/usr/bin/env bash

# ==============================================================================
# Network Configuration Script
# Author: Rouge Lin
# This script is part of my dotfiles
# ==============================================================================
#
# Purpose:
#   This script switches the system's network management from systemd-based
#   services (iwd, systemd-networkd, systemd-resolved) to NetworkManager.
#   It's designed to establish a consistent and user-friendly network management
#   solution across different Linux distributions.
#
# Functionality:
#   1. Ensures the script runs with root privileges (auto-elevates if needed)
#   2. Forcefully terminates conflicting network management processes:
#      - iwd (Intel Wireless Daemon)
#      - systemd-networkd (systemd network configuration daemon)
#      - systemd-resolved (systemd DNS resolution service)
#   3. Disables and stops the above services to prevent conflicts
#   4. Enables and starts NetworkManager service if not already active
#
# Use Cases:
#   - System initialization and dotfiles setup
#   - Resolving network manager conflicts
#   - Standardizing network management across different systems
#   - Switching from systemd networking to NetworkManager
#
# Requirements:
#   - systemd-based Linux distribution
#   - NetworkManager package installed
#   - Root/sudo privileges
#
# Warning:
#   This script will cause temporary network disconnection while switching
#   network managers. Ensure you have alternative access to the system if
#   running remotely.
#
# ==============================================================================

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
