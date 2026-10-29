FROM n8nio/n8n:2.45.5

USER root

COPY --from=mwader/static-ffmpeg:6.0 /ffmpeg /usr/local/bin/
COPY --from=mwader/static-ffmpeg:6.0 /ffprobe /usr/local/bin/

# Рабочая папка файловых нод (N8N_RESTRICT_FILE_ACCESS_TO): образ n8n её не создаёт, после пересборки её не было
# (29.10.2026, Video Creator 272784 — «The file or directory does not exist»)
RUN mkdir -p /tmp/n8n && chown node:node /tmp/n8n

ENV NODES_EXCLUDE=[]
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
# n8n 2.0: файловые ноды по умолчанию видят только ~/.n8n-files; POV «Get Video from Disk» читает /tmp/n8n
ENV N8N_RESTRICT_FILE_ACCESS_TO=/tmp/n8n
# n8n 2.0: режим «в памяти» удалён — двоичные данные храним на диске (как на проверенной копии)
ENV N8N_DEFAULT_BINARY_DATA_MODE=filesystem
# Code-нода в task runner: держим 5 минут (в будущих версиях по умолчанию станет 1 минута)
ENV N8N_RUNNERS_TASK_TIMEOUT=300
# Community-ноды не используем (аудит 25.10: только n8n-nodes-base и langchain) — установку и загрузку выключаем
ENV N8N_COMMUNITY_PACKAGES_ENABLED=false
# n8n Assistant выключен в Settings 25.10 (у нас свои агенты) — модуль не загружаем совсем (docs: set-up-n8n-assistant).
# mcp и agents НЕ выгружать: встроенный MCP нужен для проверочных запусков (n8n_test_workflow method=direct)
ENV N8N_DISABLED_MODULES=instance-ai

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
  CMD wget -qO /dev/null http://localhost:5678/healthz || exit 1

USER node
