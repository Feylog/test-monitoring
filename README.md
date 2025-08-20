# Test Process Monitor

Bash-скрипт и systemd-таймер для мониторинга процесса `test` на Linux-системах.

## 📌 Что делает:

- Проверяет, запущен ли процесс `test`
- При каждом перезапуске PID — пишет лог
- Если процесс активен — делает `curl` на API
- При ошибке curl — логирует сбой
- Работает каждую минуту через `systemd timer`

## 📁 Структура

- `scripts/test-monitor.sh` — основной bash-скрипт
- `systemd/test-monitor.service` — единичный запуск
- `systemd/test-monitor.timer` — планировщик запуска

## 🚀 Установка

```bash
sudo cp scripts/test-monitor.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/test-monitor.sh

sudo cp systemd/test-monitor.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now test-monitor.timer
```
