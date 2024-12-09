#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o pipefail
set -o nounset

Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"

PROJECT_NAME='S6 Overlay'
GH_API_URL='https://api.github.com/repos/just-containers/s6-overlay/releases/latest'

if [[ $(uname -s) != Linux ]]; then
    echo -e "${ERROR} This operating system is not supported."
    exit 1
fi

if [[ $(id -u) != 0 ]]; then
    echo -e "${ERROR} This script must be run as root."
    exit 1
fi

echo -e "${INFO} Get CPU architecture ..."
if [[ $(command -v apk) ]]; then
    PKGT='(apk)'
    OS_ARCH=$(apk --print-arch)
else
    OS_ARCH=$(uname -m)
fi
case ${OS_ARCH} in
*86)
    FILE_KEYWORD='i686'
    ;;
x86_64 | amd64)
    FILE_KEYWORD='x86_64'
    ;;
aarch64 | arm64)
    FILE_KEYWORD='aarch64'
    ;;
arm*)
    FILE_KEYWORD='armhf'
    ;;
*)
    echo -e "${ERROR} Unsupported architecture: ${OS_ARCH} ${PKGT}"
    exit 1
    ;;
esac
echo -e "${INFO} Architecture: ${OS_ARCH} ${PKGT}"

echo -e "${INFO} Get ${PROJECT_NAME} download URL ..."
DOWNLOAD_ARCH_URL=$(curl -fsSL ${GH_API_URL} | grep 'browser_download_url' | cut -d'"' -f4 | grep "${FILE_KEYWORD}" | head -n 1)
DOWNLOAD_NOARCH_URL=$(curl -fsSL ${GH_API_URL} | grep 'browser_download_url' | cut -d'"' -f4 | grep "noarch" | head -n 1)
echo -e "${INFO} Download URL: ${DOWNLOAD_URL}"

cd /tmp
echo -e "${INFO} Installing ${PROJECT_NAME} ..."
curl -LS "${DOWNLOAD_ARCH_URL}" | tar -C / -Jxpf -
curl -LS "${DOWNLOAD_NOARCH_URL}" | tar -C / -Jxpf -
echo -e "${INFO} Done."
