#!/bin/bash
# Hook: After Implementer
# После того как implementer изменил файлы, запускаем test-runner

TIMEOUT=120s

echo "[HOOK] after_implementer.sh triggered for $CURSOR_SUBAGENT_NAME"

# Запуск test-runner с таймаутом
timeout $TIMEOUT python run_test_runner.py