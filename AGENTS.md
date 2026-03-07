# AGENTS.md — Telegram Task Tracker Bot (Python)

This file describes the **project context** and **rules for AI agents** (Cursor, etc.) when working in this repository.

## Project Overview

A Python Telegram bot “Task Tracker”: create tasks from text, manage statuses and deadlines, send reminders, show today/overdue lists, and control tasks via inline buttons.

## Tech Stack

- **Language**: Python 3.10+ (see `pyproject.toml` or `requirements.txt`)
- **Telegram framework**: `aiogram` or `pyTelegramBotAPI` (`telebot`) — use whatever is already installed in the repo
- **Config/secrets**: environment variables or `.env` (never commit to the repo)
- **Storage (expected)**: SQLite/PostgreSQL (depends on deployment)
- **Testing (expected)**: `pytest`
- **Lint/format (expected)**: `ruff`, `black`, (optional `mypy`)

## Project Structure (target)

Adapt to the actual repository structure (below is the target layout):

```
bot/
  main.py          # entrypoint
  config.py        # env/.env settings
  handlers/        # Telegram handlers (thin)
  keyboards/       # inline/reply keyboards, callback data
  services/        # business logic, integrations
  utils/           # utilities
tests/
requirements.txt | pyproject.toml
.env.example
```

Architecture rules:
- Put new handlers into dedicated modules under `bot/handlers/`.
- Keep business logic in `bot/services/` or `bot/usecases/` (handlers must remain thin).
- Do not mix Telegram-specific code and pure domain logic in the same module.

## Commands

Commands depend on whether the project uses `poetry` or `pip`. If the repo already uses one, stick to it.

### Install
- `poetry install`
- or `pip install -r requirements.txt`

### Run (dev)
- `poetry run python -m bot.main`
- or `python -m bot.main`

### Tests
- `poetry run pytest`
- or `pytest`

### Lint / Typecheck / Format
- `poetry run ruff check .`
- `poetry run mypy .` (if configured)
- `poetry run black .`

## Reference Documentation (in-repo)

If these files exist, treat them as the source of truth for requirements and conventions:
- `PRD.md` — product requirements and MVP scope
- `bot/config.py` / `settings` — configuration and environment variables
- `bot/handlers/*` — commands and user flows
- `bot/services/*` — business logic

## Special Rules (Must Follow)

### Safety & Secrets
- Never commit or hardcode Telegram tokens, API keys, passwords, DSNs, or other secrets.
- Read secrets only from the environment (`os.getenv`, pydantic settings, etc.).
- Do not log private user messages; if necessary, log only minimal, anonymized data.

### Change Policy
- Prefer small, clear changes; do not do large refactors unless explicitly requested.
- Preserve the current architecture and coding style.
- Any behavior change (commands, task statuses, reminders) must include a test or at least a quick smoke check of key commands.

### Telegram Best Practices
- For `aiogram`: register handlers via routers/dispatcher; do not manually parse `update`.
- Keep callback data and commands centralized (e.g., `bot/keyboards/constants.py`).
- Log Telegram API errors, but show friendly user messages without tracebacks.

### Performance & Reliability
- Do not block the event loop (for `aiogram`): move long operations to background tasks/thread pool.
- Respect Telegram API limits; avoid spam and infinite send loops.

### Git / PR Hygiene
- One PR = one logical change.
- Keep commits small and meaningful.
- Do not commit `.env`, database dumps, or local artifacts.
- Use commit prefixes like `feature:`, `fix:`, `add:` (etc.), then `:` and a short description.

## Maintenance

`AGENTS.md` is the source of truth for AI-agent rules in this repository. If other rules appear (e.g., in `.cursor/rules`) and conflict with this file, `AGENTS.md` wins. Keep it up to date when the structure/commands/process change.

