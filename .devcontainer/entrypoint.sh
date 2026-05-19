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

# All compatible server IPs
IP1="50.7.5.83"
IP2="50.7.87.2"
IP3="50.7.87.3"
IP4="50.7.87.4"
IP5="50.7.87.5"
IP6="75.2.60.5"
IP7="144.76.1.88"
IP8="104.21.33.34"
IP9="188.114.98.0"
IP10="188.114.99.0"
IP11="3.162.247.34"
IP12="3.162.247.38"
IP13="3.162.247.45"
IP14="3.162.247.77"
IP15="3.33.186.135"
IP16="63.176.8.218"
IP17="85.10.207.48"
IP18="94.130.33.41"
IP19="95.216.69.37"
IP20="104.198.14.52"
IP21="104.21.63.202"
IP22="15.197.167.90"
IP23="172.67.150.14"
IP24="204.12.196.34"
IP25="35.157.26.135"
IP26="52.222.214.38"
IP27="52.222.214.99"
IP28="54.232.119.62"
IP29="65.109.34.234"
IP30="94.130.70.160"
IP31="138.201.54.122"
IP32="142.54.178.211"
IP33="172.67.158.128"
IP34="184.171.110.10"
IP35="52.222.214.108"
IP36="52.222.214.124"
IP37="63.141.252.203"
IP38="94.130.13.19"
IP39="94.130.50.12"
IP40="82.39.133.108"
IP41="185.219.132.82"
IP42="146.185.214.12"

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
echo "vless://${UUID}@${IP2}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP3}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP4}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP5}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP6}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP7}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP8}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP9}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP10}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP11}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP12}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP13}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP14}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP15}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP16}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP17}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP18}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP19}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP20}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP21}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP22}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP23}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP24}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP25}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP26}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP27}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP28}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP29}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP30}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP31}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP32}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP33}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP34}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP35}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP36}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP37}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP38}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP39}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP40}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP41}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo "vless://${UUID}@${IP42}:443?encryption=none&security=tls&sni=${SNI}&insecure=0&allowInsecure=0&type=ws&path=%2F#%40KakoolNews"
echo ""
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
