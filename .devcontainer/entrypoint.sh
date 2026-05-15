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

test_server() {
    if (echo >/dev/tcp/$1/443) 2>/dev/null; then
        echo "✅ $2 - $1: OK"
    else
        echo "❌ $2 - $1: BLOCKED"
    fi
}

# Test all servers
test_all() {
    echo ""
    echo "Testing servers..."
    test_server "94.130.50.12" "DE"
    test_server "63.141.252.203" "US1"
    test_server "50.7.5.83" "US2"
    echo ""
}

# Check for test command
if [ "${1:-}" = "test" ]; then
    test_all
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

# Start server test in background
(
    sleep 2
    test_all
) &

TEST_INTERVAL=1800  # Test servers every 30 minutes
last_test=0

while kill -0 "$XRAY_PID" 2>/dev/null; do
    now=$(date +%s)
    if [ $((now - last_test)) -gt $TEST_INTERVAL ]; then
        test_all
        last_test=$now
    fi
    echo "[@Kakoolnews] alive - $(date '+%H:%M:%S')"
    sleep 300
done
