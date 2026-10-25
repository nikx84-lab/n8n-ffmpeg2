FROM n8nio/n8n:2.44.6

USER root

COPY --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/
COPY --from=mwader/static-ffmpeg:6.0 /ffprobe /usr/local/bin/

ENV NODES_EXCLUDE=[]
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
# n8n 2.0: файловые ноды по умолчанию видят только ~/.n8n-files; POV «Get Video from Disk» читает /tmp/n8n
ENV N8N_RESTRICT_FILE_ACCESS_TO=/tmp/n8n
# n8n 2.0: режим «в памяти» удалён — двоичные данные храним на диске (как на проверенной копии)
ENV N8N_DEFAULT_BINARY_DATA_MODE=filesystem
# Code-нода в task runner: держим 5 минут (в будущих версиях по умолчанию станет 1 минута)
ENV N8N_RUNNERS_TASK_TIMEOUT=300

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
  CMD wget -qO /dev/null http://localhost:5678/healthz || exit 1

USER node
