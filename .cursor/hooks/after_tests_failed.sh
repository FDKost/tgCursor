#!/bin/bash
# Hook: After Tests Failed
# Если тесты упали, запускаем debugger
TIMEOUT=120s
MAX_RETRIES=3

echo "[HOOK] after_tests_failed.sh triggered for $CURSOR_SUBAGENT_NAME with result $CURSOR_SUBAGENT_RESULT, retry count $CURSOR_SUBAGENT_RETRY_COUNT"

if [ "$CURSOR_SUBAGENT_NAME" == "test-runner" ] && [ "$CURSOR_SUBAGENT_RESULT" == "failed" ]; then
    if [ "$CURSOR_SUBAGENT_RETRY_COUNT" -lt $MAX_RETRIES ]; then
        timeout $TIMEOUT python run_debugger.py
    else
        echo "[HOOK] Max retries reached for test-runner, alert human"
    fi
fi