#!/bin/bash

WORKDIR="${HOME}/Desktop"
cd "${WORKDIR}" || { echo "Cannot goto ${WORKDIR}" >&2; exit 1; }

IFS=$'\n' read -d '' -a FILE_LIST < <(
    find . -maxdepth 1 -type f -not -name ".*" -printf '%P\n' 2>/dev/null
)

SELECTED=$(printf "%s\n" "${FILE_LIST[@]}" | wofi --dmenu \
    --prompt " Desktop Files:" \
    --location top-right \
    --width 300 \
    --height 400 \
    --xoffset -0 \
    --yoffset 0 \
    --style "${HOME}/.config/wofi/style.css" \
    --conf "${HOME}/.config/wofi/config")

if [[ -n "${SELECTED}" ]]; then
    FILE_PATH="${WORKDIR}/${SELECTED}"

    if [[ ! -e "${FILE_PATH}" ]]; then
        # echo "错误：文件不存在 '${FILE_PATH}'" >&2
        exit 2
    fi

    # 简化判断逻辑：只检查可执行权限
    if [[ -x "${FILE_PATH}" ]]; then
        # echo "正在执行：${FILE_PATH}"
        nohup "${FILE_PATH}" >/dev/null 2>&1 &
    else
        # echo "正在打开：${FILE_PATH}"
        nohup xdg-open "${FILE_PATH}" >/dev/null 2>&1 &
    fi

    disown
fi
