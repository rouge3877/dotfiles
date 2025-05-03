#!/bin/bash

# 检查是否有活跃的媒体播放器
if playerctl status >/dev/null 2>&1; then
  # 获取完整元数据
  metadata=$(playerctl metadata --format '{
    "title": "{{trunc(title, 30)}}",
    "artist": "{{trunc(artist, 20)}}",
    "album": "{{trunc(album, 20)}}",
    "status": "{{status}}",
    "length": "{{duration(mpris:length)}}",
    "position": "{{duration(position)}}"
  }')
  
  # 使用jq构建JSON输出
  echo "$metadata" | jq --compact-output \
    --arg icon $(case $(playerctl status) in
                    'Playing') echo '';;
                    'Paused') echo '';;
                    *) echo '';;
                  esac) '
    {
      text: "\($icon) \(.title)",
      tooltip: "\($icon) Status: \(.status)\nArtist: \(.artist)\nAlbum: \(.album)\nDuration: \(.length)\nProgress: \(.position)",
      class: "media"
    }
  '
else
  # 无媒体播放时的默认输出
  jq --compact-output -n \
    '{
      text: " ",
      tooltip: "No media playing",
      class: "media-idle"
    }'
fi
