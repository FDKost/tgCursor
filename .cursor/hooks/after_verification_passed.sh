#!/bin/bash
# Hook: After Verification Passed
# Если verifier прошел, запускаем documenter

TIMEOUT=60s

echo "[HOOK] after_verification_passed.sh triggered for $CURSOR_SUBAGENT_NAME with result $CURSOR_SUBAGENT_RESULT"

if [ "$CURSOR_SUBAGENT_NAME" == "verifier" ] && [ "$CURSOR_SUBAGENT_RESULT" == "passed" ]; then
    timeout $TIMEOUT python run_documenter.py
fi