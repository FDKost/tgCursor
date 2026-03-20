#!/bin/bash
# Hook: After Tests Passed
# Если тесты прошли, запускаем verifier

TIMEOUT=60s

echo "[HOOK] after_tests_passed.sh triggered for $CURSOR_SUBAGENT_NAME with result $CURSOR_SUBAGENT_RESULT"

if [ "$CURSOR_SUBAGENT_NAME" == "test-runner" ] && [ "$CURSOR_SUBAGENT_RESULT" == "passed" ]; then
    timeout $TIMEOUT python run_verifier.py
fi