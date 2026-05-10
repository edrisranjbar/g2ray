FROM debian:bookworm-slim

COPY install.sh /app/install.sh

WORKDIR /app

# Install dependencies with clear output
RUN echo "📦 Installing system dependencies..." && \
    apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && echo "✅ Dependencies installed successfully" \
    && rm -rf /var/lib/apt/lists/*

# Setup and configure xray
RUN echo "⚙️  Running installation script..." && \
    chmod +x /app/install.sh && /app/install.sh && \
    echo "✅ Installation completed successfully"

COPY config.json /etc/config.json

# Create startup message with clear banner
RUN echo '#!/bin/bash' > /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "╔═══════════════════════════════════════��════════════════════╗"' >> /app/startup.sh && \
    echo 'echo "║          🚀 G2RAY - XRAY SERVICE INITIALIZED 🚀           ║"' >> /app/startup.sh && \
    echo 'echo "╚════════════════════════════════════════════════════════════╝"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "📋 Configuration:"' >> /app/startup.sh && \
    echo 'echo "   • Config File: /etc/config.json"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "🔗 VLESS Connection Details:"' >> /app/startup.sh && \
    echo 'echo "   • Link: vless://550e8400-e29b-41d4-a716-446655440000@94.130.50.12:443"' >> /app/startup.sh && \
    echo 'echo "   • Encryption: none"' >> /app/startup.sh && \
    echo 'echo "   • Security: tls"' >> /app/startup.sh && \
    echo 'echo "   • Type: xhttp"' >> /app/startup.sh && \
    echo 'echo "   • Mode: packet-up"' >> /app/startup.sh && \
    echo 'echo "   • SNI: ${CODESPACE_NAME}-443.app.github.dev"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "✨ Service is running and ready to accept connections..."' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo -e "\n✅ VLESS LINK:\nvless://550e8400-e29b-41d4-a716-446655440000@94.130.50.12:443?encryption=none&security=tls&type=xhttp&mode=packet-up&sni=${CODESPACE_NAME}-443.app.github.dev&path=%2F#ghtun"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'exec /usr/local/bin/xray -c /etc/config.json' >> /app/startup.sh && \
    chmod +x /app/startup.sh

CMD ["/app/startup.sh"]
