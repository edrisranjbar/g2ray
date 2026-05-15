#!/bin/sh
set -eu

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"

# Server list for testing
SERVERS="
94.130.50.12|DE
63.141.252.203|US1
50.7.5.83|US2
"

generate_uuid() {
    # Prefix encodes "KakoolNews" in hex: K=4b a=61 k=6b o=6f o=6f l=6c N=4e e=65 w=77 s=73
    prefix="4b616b6f-6f6c-4e65-7773"
    suffix=$(od -An -tx1 -N6 /dev/urandom | tr -d ' \n')
    echo "${prefix}-${suffix}"
}

test_server() {
    ip="$1"
    label="$2"
    # Use curl with short timeout for reliability
    if timeout 3 curl -sf "https://$ip/" --connect-timeout 2 >/dev/null 2>&1; then
        echo "✅ $label ($ip) - ONLINE"
    elif timeout 3 curl -sf "http://$ip/" --connect-timeout 2 >/dev/null 2>&1; then
        echo "✅ $label ($ip) - ONLINE (HTTP)"
    else
        echo "❌ $label ($ip) - OFFLINE/TIMEOUT"
    fi
}

background_test() {
    # Run server tests in background and print results after a few seconds
    (
        sleep 2
        echo ""
        echo "🌐 Server Status (auto-tested):"
        echo "$SERVERS" | while read -r ip label; do
            [ -n "$ip" ] && test_server "$ip" "$label"
        done
        echo ""
    ) &
}

show_status() {
    echo ""
    echo "🌐 Testing servers..."
    echo ""
    echo "$SERVERS" | while read -r ip label; do
        [ -n "$ip" ] && test_server "$ip" "$label"
    done
    echo ""
}

# Check for test command
if [ "${1:-}" = "test" ]; then
    show_status
    exit 0
fi

UUID="${VLESS_UUID:-$(generate_uuid)}"

sed "s/\${UUID}/$UUID/g" "$CONFIG_TEMPLATE" > "$CONFIG"

SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"

echo ""
echo "========================================"
echo "  @Kakoolnews - VLESS Proxy"
echo "========================================"
echo ""
echo "VLESS links (copy & use whichever works):"
echo ""
echo "vless://${UUID}@94.130.50.12:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@kakoolnews"
echo ""
echo "vless://${UUID}@63.141.252.203:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@kakoolnews"
echo ""
echo "vless://${UUID}@50.7.5.83:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@kakoolnews"
echo ""
echo "========================================"
echo ""

/usr/local/bin/xray -c "$CONFIG" &
XRAY_PID=$!

# Start background server test
background_test

TEST_INTERVAL=1800  # Test servers every 30 minutes
last_test=0

while kill -0 "$XRAY_PID" 2>/dev/null; do
    now=$(date +%s)
    if [ $((now - last_test)) -gt $TEST_INTERVAL ]; then
        background_test
        last_test=$now
    fi
    echo "[@Kakoolnews] alive - $(date '+%H:%M:%S')"
    sleep 300
done
