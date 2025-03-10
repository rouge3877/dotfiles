# Set shell proxy

proxy_on() {
  export https_proxy=http://127.0.0.1:7897;
  export http_proxy=http://127.0.0.1:7897;
  export all_proxy=socks5://127.0.0.1:7897;
  echo "Proxy on"
}

proxy_off() {
  unset https_proxy;
  unset http_proxy;
  unset all_proxy;
  echo "Proxy off"
}

proxy_print() {
  echo "https_proxy: $https_proxy"
  echo "http_proxy: $http_proxy"
  echo "all_proxy: $all_proxy"
}

# Other useful functions

