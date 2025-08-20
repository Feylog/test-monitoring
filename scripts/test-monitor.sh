#!/bin/bash

PROCESS_NAME="test"
LOG_FILE="/var/log/monitoring.log"
STATE_FILE="/var/run/${PROCESS_NAME}.pid"
MONITOR_URL="https://test.com/monitoring/test/api"

# Получить текущий PID процесса test
CURRENT_PID=$(pgrep -x "$PROCESS_NAME" | head -n 1)

# Если процесс не найден — ничего не делать
if [ -z "$CURRENT_PID" ]; then
  exit 0
fi

# Проверить, был ли перезапуск
if [ -f "$STATE_FILE" ]; then
  LAST_PID=$(cat "$STATE_FILE")
else
  LAST_PID=""
fi

# Если PID изменился, значит был перезапуск
if [ "$CURRENT_PID" != "$LAST_PID" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Process $PROCESS_NAME restarted. New PID: $CURRENT_PID" >> "$LOG_FILE"
fi

# Сохраняем текущий PID в файл
echo "$CURRENT_PID" > "$STATE_FILE"

# Пингуем monitoring-сервер
curl -s --max-time 5 --retry 2 --retry-delay 2 "$MONITOR_URL" > /dev/null
if [ $? -ne 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] Failed to reach $MONITOR_URL" >> "$LOG_FILE"
fi