#!/bin/bash
# Hook: After Verification Failed
# Если verifier не прошел, возвращаем implementer

TIMEOUT=120s
MAX_RETRIES=3

echo "[HOOK] after_verification_failed.sh triggered for $CURSOR_SUBAGENT_NAME with result $CURSOR_SUBAGENT_RESULT, retry count $CURSOR_SUBAGENT_RETRY_COUNT"

if [ "$CURSOR_SUBAGENT_NAME" == "verifier" ] && [ "$CURSOR_SUBAGENT_RESULT" == "failed" ]; then
    if [ "$CURSOR_SUBAGENT_RETRY_COUNT" -lt $MAX_RETRIES ]; then
        timeout $TIMEOUT python run_implementer.py
    else
        echo "[HOOK] Max retries reached for verifier, alert human"
    fi
fi