#!/bin/bash
CONFIG="/etc/xray/g2ray.json"
UUID=$(grep -o '"id": *"[^"]*"' "$CONFIG" | head -1 | grep -o '"[^"]*"$' | tr -d '"')
if [ -z "$UUID" ]; then echo "[g2ray] UUID پیدا نشد."; exit 1; fi
HOST="${CODESPACE_NAME}-443.app.github.dev"
LINK="vless://${UUID}@${HOST}:443?encryption=none&security=tls&sni=${HOST}&type=xhttp&mode=packet-up&path=%2F#Shayan"
echo ""
echo "================================================"
echo "  $LINK"
echo "================================================"
echo ""