#!/usr/bin/env bash



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
        sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 mem_sleep_default=deep\"|" /etc/default/grub
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
