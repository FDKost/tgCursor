# AGENTS.md — Telegram Task Tracker Bot (Python)

Этот файл описывает **контекст проекта** и **правила для ИИ‑агентов** (Cursor и др.) при работе с этим репозиторием. 

## Project Overview

Python‑проект Telegram‑бота «Трекер задач»: создание задач из текста, статусы, дедлайны, напоминания, списки today/overdue и управление через inline‑кнопки.

## Tech Stack

- **Language**: Python 3.10+ (см. `pyproject.toml` или `requirements.txt`)
- **Telegram framework**: `aiogram` или `pyTelegramBotAPI` (`telebot`) — используй то, что уже подключено в проекте
- **Config/secrets**: env‑переменные или `.env` (в репозиторий не коммитить)
- **Storage (expected)**: SQLite/PostgreSQL (уточняется по проекту)
- **Testing (expected)**: `pytest`
- **Lint/format (expected)**: `ruff`, `black`, (опционально `mypy`)

## Project Structure (target)

Адаптируй под реальную структуру репозитория (ниже — целевая схема):

```
bot/
  main.py          # entrypoint
  config.py        # env/.env settings
  handlers/        # Telegram handlers (тонкие)
  keyboards/       # inline/reply keyboards, callback data
  services/        # бизнес-логика, интеграции
  utils/           # утилиты
tests/
requirements.txt | pyproject.toml
.env.example
```

Правила по архитектуре:
- Новые обработчики — в отдельных модулях `bot/handlers/`.
- Бизнес‑логика — в `bot/services/` или `bot/usecases/` (хендлеры остаются тонкими).
- Не смешивать Telegram‑специфичный код и доменную логику в одном модуле.

## Commands

Команды зависят от того, `poetry` или `pip`. Если в проекте нет явного выбора — придерживайся того, что уже используется.

### Install
- `poetry install`
- или `pip install -r requirements.txt`

### Run (dev)
- `poetry run python -m bot.main`
- или `python -m bot.main`

### Tests
- `poetry run pytest`
- или `pytest`

### Lint / Typecheck / Format
- `poetry run ruff check .`
- `poetry run mypy .` (если подключён)
- `poetry run black .`

## Reference Documentation (in-repo)

Если эти файлы есть — используй их как «источник истины» по требованиям и соглашениям:
- `PRD.md` — продуктовые требования и MVP‑скоуп
- `bot/config.py` / `settings` — конфигурация и env‑переменные
- `bot/handlers/*` — команды и user‑flows
- `bot/services/*` — бизнес‑логика

## Special Rules (Must Follow)

### Safety & Secrets
- Никогда не коммить и не хардкодить: токены Telegram, API‑ключи, пароли, DSN.
- Секреты берём только из окружения (`os.getenv`, pydantic settings и т.п.).
- Не логировать приватные сообщения пользователей; при необходимости — только минимально и анонимизировано.

### Change Policy
- Предпочитай маленькие, понятные изменения; не делай большой рефакторинг без запроса.
- Сохраняй текущий стиль и архитектуру проекта.
- Любые изменения поведения бота (команды, статусы задач, напоминания) — сопровождай тестом или хотя бы «smoke‑проверкой» ключевых команд.

### Telegram Best Practices
- Для `aiogram`: регистрируй хендлеры через роутеры/диспетчер, не вручную разбирай `update`.
- Callback‑данные и команды держи централизованно (например, `bot/keyboards/constants.py`).
- Ошибки Telegram API логируй, но пользователю показывай дружелюбные сообщения без трейсбеков.

### Performance & Reliability
- Не блокируй event loop (для `aiogram`): долгие операции выноси в фон/пул.
- Следи за лимитами Telegram API, избегай спама и бесконечных циклов отправки.

### Git / PR Hygiene
- Один PR — одна логическая задача.
- Коммиты небольшие и осмысленные.
- Не коммить `.env`, дампы БД и локальные артефакты.
- Пиши feature,fix,add и тд в начале, после ставь : и рассказывай что сделал.

## Maintenance

`AGENTS.md` — источник истины для правил работы ИИ‑агентов в этом репо. Если появляются другие правила (например, в `.cursor/rules`) и есть конфликт — приоритет у `AGENTS.md`. Обновляй файл при изменении структуры/команд/процессов.

