# @Kakoolnews

> Automated VLESS proxy setup via GitHub Codespaces — works anywhere Codespaces is available.

## Warning

**Use a secondary GitHub account (not your main account)** when forking and running this project. Running proxy servers may trigger GitHub's automated security systems or account restrictions.

## Features

- **Fixed UUID** — consistent identity across all sessions (no hardcoded credentials)
- **Latest Xray** — automatically fetches the newest stable Xray-core release at build time
- **Multi-architecture** — supports amd64, arm64, and armv7
- **Traffic sniffing** — detects HTTP/TLS for smarter routing
- **BitTorrent blocking** — prevents accidental P2P traffic through the proxy
- **Health checks** — built-in Docker health monitoring
- **Custom UUID** — optionally set `VLESS_UUID` env var to use your own UUID

## Quick Start

1. Fork this repository (use a secondary account)
2. Click **Code** > **Codespaces** > **Create codespace on main**
3. Wait 2–5 minutes for setup to complete
4. Copy the VLESS link printed in the terminal

### Import the Link

Use the generated VLESS link in any compatible proxy client:

- [V2RayNG](https://github.com/2dust/v2rayNG) (Android)
- [V2RayN](https://github.com/2dust/v2rayN) (Windows)
- [Netch](https://github.com/netchx/netch) (Windows — gaming/TUN mode)
- [Clash Meta](https://github.com/MetaCubeX/ClashMetaForAndroid) (Android)
- [Nekoray](https://github.com/MatsuriDayo/nekoray) (Linux/Windows)

## Configuration

### Custom UUID

Set the `VLESS_UUID` environment variable in your Codespace to use a specific UUID instead of an auto-generated one:

```
VLESS_UUID=your-custom-uuid-here
```

### Xray Config

The proxy configuration is in `.devcontainer/config.json`. Key settings:

| Setting | Value | Description |
|---------|-------|-------------|
| Port | 443 | Inbound VLESS port |
| Protocol | VLESS | Proxy protocol |
| Transport | WebSocket | Stream transport type |
| Path | / | WebSocket path |
| Sniffing | enabled | HTTP/TLS traffic detection |

## Codespace Quota

GitHub provides **120 free core-hours/month**:

| Cores | Hours/Month |
|-------|-------------|
| 2 | 60 |
| 4 | 30 |
| 8 | 15 |

**Stop your Codespace when not in use** to conserve hours.

## Compatible Networks

Tested with Shecan (free plan). If these IPs are reachable from your network, the proxy should work:

- `50.7.5.83`, `50.7.87.2`, `50.7.87.3`, `50.7.87.4`, `50.7.87.5`
- `75.2.60.5`, `144.76.1.88`, `104.21.33.34`, `188.114.98.0`, `188.114.99.0`
- `3.162.247.34`, `3.162.247.38`, `3.162.247.45`, `3.162.247.77`, `3.33.186.135`
- `63.176.8.218`, `85.10.207.48`, `94.130.33.41`, `95.216.69.37`, `104.198.14.52`
- `104.21.63.202`, `15.197.167.90`, `172.67.150.14`, `204.12.196.34`, `35.157.26.135`
- `52.222.214.38`, `52.222.214.99`, `54.232.119.62`, `65.109.34.234`, `94.130.70.160`
- `138.201.54.122`, `142.54.178.211`, `172.67.158.128`, `184.171.110.10`
- `52.222.214.108`, `52.222.214.124`, `63.141.252.203`
- `94.130.13.19`, `94.130.50.12`, `82.39.133.108`, `185.219.132.82`, `146.185.214.12`

All 42 compatible server IPs are automatically printed when starting the Codespace.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Codespace fails to start | Delete it and create a new one |
| No VLESS link shown | Check the terminal output for errors |
| Connection timeout | Try a different datacenter or ISP |
| Port not accessible | Ensure port 443 is set to public visibility |

## Project Structure

```
.devcontainer/
  Dockerfile          # Container image definition
  config.json         # Xray configuration template (UUID injected at runtime)
  devcontainer.json   # Codespace settings and lifecycle hooks
  entrypoint.sh       # Startup script: generates UUID, configures Xray, prints VLESS link
  install.sh          # Downloads and installs the latest Xray binary
docs/
  screenshot.png      # Terminal screenshot for reference
```

## Support

- [Buy me a coffee](https://www.buymeacoffee.com/amiremohamadi)
- Ethereum: `0x5724c38100b2aE3d2547974f46D0f2f49eb2D152`

## Disclaimer

This tool is for educational and legitimate use only. Users are responsible for complying with local laws and regulations regarding proxy usage. The author is not responsible for any misuse.

## License

This project is open-source. See the LICENSE file for details.
