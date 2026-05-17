#!/bin/sh
set -e
RELEASE="https://github.com/XTLS/Xray-core/releases/download/v26.3.27/Xray-linux-64.zip"
TMPDIR="$(mktemp -d)"
echo "[g2ray] Downloading Xray v26.3.27..."
curl -sL "$RELEASE" -o "$TMPDIR/xray.zip"
unzip -q "$TMPDIR/xray.zip" -d "$TMPDIR"
install -m 755 "$TMPDIR/xray" /usr/local/bin/xray
echo "[g2ray] Downloading GeoIP and GeoSite..."
curl -sL "https://github.com/v2fly/geoip/releases/latest/download/geoip.dat" -o /usr/local/bin/geoip.dat
curl -sL "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat" -o /usr/local/bin/geosite.dat
rm -rf "$TMPDIR"
echo "[g2ray] Done."