########### About System ###########

# Get the OS name
get_os_name() {
    local os=$(cat /etc/os-release | awk -F= '/^NAME/ {print $2}' | tr -d '"' | awk '{print $1}')
    echo $os
}

# Get the Kernel version
get_kernel_version() {
    local kernel=$(uname -r)
    echo $kernel
}

# Get the CPU information
get_cpu_info() {
    local cpu=$(lscpu | awk '/Model name/ {print $3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}')
    echo $cpu
}

# Get the memory usage, print using |vertical bar to print a diagram in the terminal
get_memory_usage() {
    local memory=$(free -h | awk '/Mem/ {print $3"/"$2}')

}

# Get battrey status, if the system is not a laptop, it will return "999%"
get_battery_usage() {
    local battery_file="/sys/class/power_supply/BAT1/capacity"
    if [[ -f $battery_file ]]; then
        local battery=$(cat $battery_file)
        echo $battery"%"
    else
        echo "999%"
    fi
}

# Get the disk usage
get_disk_usage() {
    local disk=$(df -h | awk '/\/$/ {print $3"/"$2}')
    echo $disk
}

