#!/bin/sh
set -eu

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"
PID_FILE="/tmp/xray.pid"

# Fixed UUID - same for all Codespaces
UUID="0efb1a4a-0513-471c-b762-bd66a336044c"

SERVER_IP="${SERVER_IP:-localhost}"

sed "s/\${UUID}/$UUID/g" "$CONFIG_TEMPLATE" > "$CONFIG"

SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"

IP1="50.7.5.83"
IP2="94.130.50.12"
IP3="63.141.252.203"

get_usage() {
    if [ -f /proc/net/dev ]; then
        awk '/^ *(eth0|ens|wlan|tun0)/{sum += $2 + $10} END {printf "%.0f", sum+0}' /proc/net/dev 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

format_bytes() {
    bytes=$(printf "%.0f" "$1" 2>/dev/null)
    if [ -z "$bytes" ] || [ "$bytes" = "0" ]; then
        echo "0B"
        return
    fi
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$((bytes / 1024))KB"
    elif [ "$bytes" -lt 1073741824 ]; then
        echo "$((bytes / 1048576))MB"
    else
        echo "$((bytes / 1073741824))GB"
    fi
}

restart_xray() {
    pkill -f xray 2>/dev/null || true
    sleep 1
    /usr/local/bin/xray -c "$CONFIG" &
    echo "$!" > "$PID_FILE"
    echo "Xray restarted"
}

echo ""
echo "========================================"
echo "  @KakoolNews - VLESS Proxy"
echo "========================================"
echo ""
echo "Your VLESS links:"
echo ""
echo "vless://${UUID}@${IP1}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo ""
echo "vless://${UUID}@${IP2}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo ""
echo "vless://${UUID}@${IP3}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo ""
echo "========================================"
echo "Data: $(format_bytes $(get_usage))"
echo "========================================"
echo ""
echo "Commands:"
echo "  restart: pkill -f xray; sleep 1; /usr/local/bin/xray -c $CONFIG &"
echo "  usage:   cat /proc/net/dev | grep eth0"
echo ""

/usr/local/bin/xray -c "$CONFIG" &
echo "$!" > "$PID_FILE"

while kill -0 "$(cat "$PID_FILE")" 2>/dev/null; do
    echo "[@KakoolNews] alive - $(date '+%H:%M:%S') Data: $(format_bytes $(get_usage))"
    sleep 300
done
