#!/bin/sh
set -eu

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"

UUID="${VLESS_UUID:-0efb1a4a-0513-471c-b762-bd66a336044c}"

generate_config() {
    sed "s/\${UUID}/$UUID/g" "$CONFIG_TEMPLATE" > "$CONFIG"
}

get_usage() {
    # Get network stats from /proc - total bytes on all interfaces
    if [ -f /proc/net/dev ]; then
        awk '/^ *(eth0|ens|wlan|tun0|wg0)/{sum += $2 + $10} END {print sum+0}' /proc/net/dev 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

format_bytes() {
    bytes=$1
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
    echo "[@KakoolNews] Restarting Xray..."
    if [ -n "$XRAY_PID" ] && kill -0 "$XRAY_PID" 2>/dev/null; then
        kill "$XRAY_PID" 2>/dev/null || true
        sleep 1
    fi
    generate_config
    /usr/local/bin/xray -c "$CONFIG" &
    XRAY_PID=$!
    echo "[@KakoolNews] Xray restarted"
}

show_stats() {
    usage=$(get_usage)
    formatted=$(format_bytes "$usage")
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
    echo "  Total Data: $formatted"
    echo "========================================"
    echo ""
}

# Handle signals
trap 'restart_xray' HUP
trap 'show_stats' USR1

SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"

# Compatible IPs from README
IP1="50.7.5.83"
IP2="94.130.50.12"
IP3="63.141.252.203"

generate_config

show_stats

/usr/local/bin/xray -c "$CONFIG" &
XRAY_PID=$!

while kill -0 "$XRAY_PID" 2>/dev/null; do
    echo "[@KakoolNews] alive - $(date '+%H:%M:%S')"
    sleep 300
done
