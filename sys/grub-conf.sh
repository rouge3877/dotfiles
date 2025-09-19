#!/usr/bin/env bash

# ==============================================================================
# GRUB Configuration Script
# Author: Rouge Lin
# This script is part of my dotfiles
# ==============================================================================
#
# Purpose:
#   This script automates the configuration of GRUB bootloader with a custom
#   Minecraft-themed visual theme and optimizes system sleep behavior for
#   better power management on Linux systems.
#
# Functionality:
#   1. Theme Installation:
#      - Downloads and installs the "minegrub-theme" from GitHub
#      - Copies theme files to /boot/grub/themes/minegrub/
#      - Updates GRUB configuration to use the new theme
#
#   2. Sleep Configuration:
#      - Adds "mem_sleep_default=deep" kernel parameter to GRUB_CMDLINE_LINUX_DEFAULT
#      - Enables deep sleep mode for better battery life on laptops
#      - Prevents duplicate entries if parameter already exists
#
#   3. Configuration Management:
#      - Intelligently handles existing GRUB_THEME entries (commented or uncommented)
#      - Preserves existing kernel parameters while adding new ones
#      - Provides user confirmation before applying changes
#      - Automatically regenerates GRUB configuration file
#
# Features:
#   - Root privilege escalation (auto-elevates if needed)
#   - Duplicate parameter detection and prevention
#   - User confirmation for configuration changes
#   - Colored output for warnings and status messages
#   - Automatic GRUB configuration regeneration
#
# Use Cases:
#   - Personalizing GRUB bootloader appearance
#   - Optimizing laptop power management
#   - System customization as part of dotfiles setup
#   - Standardizing boot configuration across multiple systems
#
# Requirements:
#   - GRUB bootloader installed
#   - Internet connection (for theme download)
#   - Root/sudo privileges
#   - Git installed
#
# Warning:
#   Modifying GRUB configuration can affect system boot behavior.
#   Ensure you have a recovery method available before running this script.
#
# ==============================================================================

# Function to configure GRUB
conf() {
    git clone https://github.com/Lxtharia/minegrub-theme.git /tmp/minegrub-theme
    cd /tmp/minegrub-theme
    cp -ruv ./minegrub /boot/grub/themes/

    # Find the line of "GRUB_THEME" or "#GRUB_THEME" in /etc/default/grub
    # If it exists, replace it with "GRUB_THEME=/boot/grub/themes/minegrub/theme.txt"
    # If it doesn't exist, add "GRUB_THEME=/boot/grub/themes/minegrub/theme.txt" to the end of the file

    if grep -q "GRUB_THEME" /etc/default/grub; then
        sed -i "s|^GRUB_THEME=.*|GRUB_THEME=/boot/grub/themes/minegrub/theme.txt|" /etc/default/grub
    elif grep -q "#GRUB_THEME" /etc/default/grub; then
        sed -i "s|^#GRUB_THEME=.*|GRUB_THEME=/boot/grub/themes/minegrub/theme.txt|" /etc/default/grub
    else
        echo "GRUB_THEME=/boot/grub/themes/minegrub/theme.txt" >> /etc/default/grub
    fi

    # add mem_sleep_default=deep to the GRUB_CMDLINE_LINUX_DEFAULT line
    if grep -q "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub; then
        # check if the line already contains "mem_sleep_default=deep"
        if grep -q "mem_sleep_default=deep" /etc/default/grub; then
            # echo as red bold for warning
            echo -e "\e[31;1mThe line already contains mem_sleep_default=deep\e[0m"
        else
            # replace the line with the new line
            sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 mem_sleep_default=deep\"|" /etc/default/grub
        fi
    else
        echo "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash mem_sleep_default=deep\"" >> /etc/default/grub
    fi

    # cat the /etc/default/grub file to check if the line is added or replaced
    # user should check and print y or n
    cat /etc/default/grub
    echo "Is the line added or replaced? (y/n)"
    read answer
    if [ "$answer" == "y" ]; then
        echo "The line is added or replaced successfully."
        grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo "The line is not added or replaced."
    fi
}

# Check if the script is run as root
# If not, ask the password and run the script as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please enter your password."
    exec sudo bash "$0" "$@"
fi

conf

# make grub
grub-mkconfig -o /boot/grub/grub.cfg
