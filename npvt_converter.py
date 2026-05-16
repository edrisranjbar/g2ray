#!/usr/bin/env python3
import argparse
import urllib.parse
import sys

def parse_vless_url(url):
    if not url.startswith("vless://"):
        print("Error: URL must start with vless://")
        sys.exit(1)
    url = url[8:]  # vless:// = 8 chars
    remarks = ""
    if "#" in url:
        url, remarks = url.split("#", 1)
        remarks = urllib.parse.unquote(remarks)
    return url.strip(), remarks

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate VLESS URL")
    parser.add_argument("--vless", help="VLESS URL")
    parser.add_argument("--text", help="Custom remarks")
    args = parser.parse_args()

    if not args.vless:
        print("Usage: python npvt_converter.py --vless vless://... --text MyServer")
        sys.exit(1)

    server_part, remarks = parse_vless_url(args.vless)
    if args.text:
        remarks = args.text

    if remarks:
        output = f"vless://{server_part}#@{remarks}"
    else:
        output = f"vless://{server_part}"

    print(output)
