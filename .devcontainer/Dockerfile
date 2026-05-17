FROM debian:bookworm-slim
COPY setup.sh /tmp/setup.sh
COPY config.json /etc/xray/g2ray.json
COPY show-link.sh /usr/local/bin/show-link.sh
COPY start.sh /usr/local/bin/start.sh
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash curl wget unzip ca-certificates openssl uuid-runtime \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /tmp/setup.sh \
    && /tmp/setup.sh \
    && rm /tmp/setup.sh \
    && chmod +x /usr/local/bin/show-link.sh \
    && chmod +x /usr/local/bin/start.sh
EXPOSE 443
CMD ["/usr/local/bin/xray","run","-c","/etc/xray/g2ray.json"]