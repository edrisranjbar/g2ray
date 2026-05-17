#!/bin/sh
set -eu

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"

generate_uuid() {
    # Prefix encodes "KakoolNews" in hex: K=4b a=61 k=6b o=6f o=6f l=6c N=4e e=65 w=77 s=73
    prefix="4b616b6f-6f6c-4e65-7773"
    suffix=$(od -An -tx1 -N6 /dev/urandom | tr -d ' \n')
    echo "${prefix}-${suffix}"
}

# Get your VPS IP from env or use default
SERVER_IP="${SERVER_IP:-localhost}"

UUID="${VLESS_UUID:-$(generate_uuid)}"

sed "s/\${UUID}/$UUID/g" "$CONFIG_TEMPLATE" > "$CONFIG"

SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"

# Compatible IPs from README
IP1="50.7.5.83"
IP2="94.130.50.12"
IP3="63.141.252.203"

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
echo ""

while true; do
    /usr/local/bin/xray -c "$CONFIG"
    echo "[@KakoolNews] xray stopped, waiting 5 min then restarting..."
    sleep 300
done
