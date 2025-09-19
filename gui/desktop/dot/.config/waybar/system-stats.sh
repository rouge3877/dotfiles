#!/bin/bash

# 获取CPU温度
temp=$(sensors | awk '/Package id 0:/ {print $4}' | tr -d '+°C')

# 获取CPU使用率
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# 获取CPU负载
load=$(uptime | awk -F'[a-z]:' '{print $2}' | xargs)

# 获取内存信息
ram=$(free -m | awk '/Mem:/ {printf "%.1f/%.1f GiB (%d%%)", $3/1024, $2/1024, $3/$2*100}')
swap=$(free -m | awk '/Swap:/ {printf "%.1f/%.1f GiB (%d%%)", $3/1024, $2/1024, ($2>0 ? $3/$2*100 : 0)}')

# 获取磁盘信息
disk=$(df -h / | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}')

# 使用真实换行符构建工具提示
tooltip=$(printf " CPU Usage: %s\\n Load Avg: %s\\n󰍛 Memory: %s\\n󰾴 Swap: %s\\n󰋊 Disk: %s" \
          "$cpu_usage" "$load" "$ram" "$swap" "$disk")

# 生成JSON输出
JSON=$(jq --compact-output -n \
  --arg text "${temp}°C" \
  --arg tooltip "$tooltip" \
  --arg class "system-info" \
  '{text: $text, tooltip: $tooltip, class: $class}')

echo "$JSON"
