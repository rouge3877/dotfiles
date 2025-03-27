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


