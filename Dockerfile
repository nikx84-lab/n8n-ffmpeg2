FROM n8nio/n8n:1.123.71

USER root

COPY --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/
COPY --from=mwader/static-ffmpeg:6.0 /ffprobe /usr/local/bin/

ENV NODES_EXCLUDE=[]
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
  CMD wget -qO /dev/null http://localhost:5678/healthz || exit 1

USER node
