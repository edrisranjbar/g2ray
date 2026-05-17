#!/bin/sh
set -eu

XRAY_DIR="/usr/local/bin"

# Skip if already installed
if [ -x "$XRAY_DIR/xray" ]; then
    echo "Xray already installed."
    exit 0
fi

detect_arch() {
    arch="$(uname -m)"
    case "$arch" in
        x86_64|amd64) echo "64" ;;
        aarch64|arm64) echo "arm64-v8a" ;;
        armv7*) echo "arm32-v7a" ;;
        *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
    esac
}

fetch_latest_version() {
    # Try cached version first
    if [ -f /tmp/xray_version ]; then
        version=$(cat /tmp/xray_version)
        if [ -n "$version" ]; then
            echo "$version"
            return
        fi
    fi
    version=$(wget -qO- "https://api.github.com/repos/XTLS/Xray-core/releases/latest" \
        | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//')
    if [ -z "$version" ]; then
        echo "Failed to fetch latest Xray version" >&2
        exit 1
    fi
    echo "$version" > /tmp/xray_version
    echo "$version"
}

ARCH="$(detect_arch)"
VERSION="$(fetch_latest_version)"
URL="https://github.com/XTLS/Xray-core/releases/download/${VERSION}/Xray-linux-${ARCH}.zip"

echo "Downloading Xray ${VERSION} for linux-${ARCH}..."
wget -O /tmp/xray.zip "$URL"

echo "Installing Xray..."
unzip -o /tmp/xray.zip -d /tmp/xray
chmod +x /tmp/xray/xray
mv /tmp/xray/xray "$XRAY_DIR/xray"

rm -rf /tmp/xray.zip /tmp/xray
echo "Xray ${VERSION} installed successfully."
