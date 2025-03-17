# This is about the utilities that I use in my daily life.

########### About Network ###########
# Get public IP address
get_public_ip() {
    local ip=$(curl -s "http://whatismyip.akamai.com/")

    if [[ -n $http_proxy ]]; then
        # italic if behind proxy
        echo -e "\e[3m$ip\e[0m"
    else
        echo $ip
    fi
}

get_local_ip() {
    if [[ $1 == "-4" ]]; then
        local ip=$( ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | head -n 1 )

        if [[ -n $http_proxy ]]; then
            # italic if behind proxy
            echo -e "\e[3m$ip\e[0m" | tr -d '\n'
        else
            echo $ip | tr -d '\n'
        fi
    elif [[ $1 == "-6" ]]; then
        local ipv6=$( ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | tail -n 1 )
        if [[ -z $ipv6 ]]; then
            echo "IPv6 is not supported" | tr -d '\n'
            return
        fi
        if [[ -n $http_proxy ]]; then
            # italic if behind proxy
            echo -e "\e[3m$ipv6\e[0m" | tr -d '\n'
        else
            echo $ipv6 | tr -d '\n'
        fi
    else
        echo "Usage: get_local_ip [-4|-6]"
    fi
}
    

# Get the MAC address of the network interface
get_mac_address() {
    local mac=$(ip link show | awk '/link\/ether/ {print $2}' | head -n 1)

    if [[ -n $http_proxy ]]; then
        # italic if behind proxy
        echo -e "\e[3m$mac\e[0m" | tr -d '\n'
    else
        echo $mac | tr -d '\n'
    fi
}


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

