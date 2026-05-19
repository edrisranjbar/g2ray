#!/bin/sh
# Export script for g2ray - generates config files for various clients
# Supports: NPV Tunnel, V2RayNG, V2RayN, and other V2Ray clients

set -eu

CONFIG_TEMPLATE="/workspaces/g2ray/.devcontainer/config.json"
OUTPUT_DIR="/workspaces/g2ray/.devcontainer/output"

# Default values
SERVER_IP="${SERVER_IP:-localhost}"
SERVER_PORT="${SERVER_PORT:-443}"
CODESPACE_NAME="${CODESPACE_NAME:-localhost}"

generate_uuid() {
    prefix="4b616b6f-6f6c-4e65-7773"
    suffix=$(od -An -tx1 -N6 /dev/urandom | tr -d ' \n')
    echo "${prefix}-${suffix}"
}

export_config() {
    UUID="${VLESS_UUID:-$(generate_uuid)}"
    SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"
    
    mkdir -p "$OUTPUT_DIR"
    
    # 1. Standard Xray JSON config (works with most clients including NPV Tunnel)
    sed "s/\${UUID}/$UUID/g" "$CONFIG_TEMPLATE" > "$OUTPUT_DIR/config.json"
    
    # 2. VLESS URL (universal shareable link)
    VLESS_URL="vless://${UUID}@${SERVER_IP}:${SERVER_PORT}?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@kakoolnews"
    echo "$VLESS_URL" > "$OUTPUT_DIR/vless.txt"
    
    # 3. NPV Tunnel specific format (JSON with custom fields)
    cat > "$OUTPUT_DIR/config.npv.json" << EOF
{
  "protocol": "vless",
  "server": "${SERVER_IP}",
  "port": ${SERVER_PORT},
  "uuid": "${UUID}",
  "encryption": "none",
  "transport": "ws",
  "path": "/",
  "tls": true,
  "sni": "${SNI}",
  " Remarks": "@kakoolnews"
}
EOF
    
    echo "Configs exported to $OUTPUT_DIR/"
    echo ""
    echo "Files created:"
    echo "  - config.json       (Standard Xray/JSON config)"
    echo "  - config.npv.json  (NPV Tunnel format)"
    echo "  - vless.txt        (VLESS URL link)"
}

# Run if executed directly
if [ -f "$CONFIG_TEMPLATE" ]; then
    export_config
fi