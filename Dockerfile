FROM n8nio/n8n:2.65.2

USER root


COPY --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/
COPY --from=mwader/static-ffmpeg:6.0 /ffprobe /usr/local/bin/


ENV NODES_EXCLUDE=[]


ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678

USER node
