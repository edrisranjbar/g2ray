FROM debian:bookworm-slim

COPY install.sh /app/install.sh

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /app/install.sh && /app/install.sh
COPY config.json /etc/config.json

RUN echo 'echo -e "Sham-VPN"' >> /etc/bash.bashrc

CMD ["/usr/local/bin/xray", "-c", "/etc/config.json"]
