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

echo ""
echo "========================================"
echo "  @KakoolNews - VLESS Proxy"
echo "========================================"
echo ""
echo "Your VLESS link:"
echo ""
echo "vless://${UUID}@${SERVER_IP}:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@KakoolNews"
echo ""
echo "Compatible IPs:"
echo "  - 63.141.252.203"
echo "  - 50.7.5.83"
echo "  - 94.130.50.12"
echo ""
echo "========================================"
echo ""

/usr/local/bin/xray -c "$CONFIG" &
XRAY_PID=$!

while kill -0 "$XRAY_PID" 2>/dev/null; do
    echo "[@KakoolNews] alive - $(date '+%H:%M:%S')"
    sleep 300
done
