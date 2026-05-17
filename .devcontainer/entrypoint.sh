#!/bin/sh

# VLESS UUID - same for all Codespaces
UUID="0efb1a4a-0513-471c-b762-bd66a336044c"

# Compatible IPs
IP1="50.7.5.83"
IP2="94.130.50.12"
IP3="63.141.252.203"

# Get SNI from Codespace name or use default
SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"

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

# Generate config with UUID
sed "s/\${UUID}/$UUID/g" /etc/config.template.json > /etc/config.json

# Start Xray in background
/usr/local/bin/xray -c /etc/config.json &

# Keep running and show alive every 5 minutes
while true; do
    sleep 300
    echo "[@KakoolNews] alive - $(date '+%H:%M:%S')"
done
