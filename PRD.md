# Product Requirements Document: Telegram Task Tracker Bot

## Executive Summary

**Telegram Task Tracker Bot** is a Telegram bot for personal task management: fast inbox capture, statuses, deadlines, reminders, and a daily progress overview directly in chat.

The MVP focuses on **fast input** (1 command → 1 task), **deadline control** (today/overdue), and **inline task management** without extra “screens”.

## Mission

**Product mission:** help users avoid losing tasks and get them done through frictionless capture and effective reminders.

### Principles
1. **Fast capture** — a task is added faster than it can be forgotten.
2. **Focus** — the interface highlights what to do now (doing/today/overdue).
3. **Low friction** — manage tasks via inline buttons with minimal commands.
4. **Respect user time** — reminders are useful, configurable, and non-spammy.
5. **Private by default** — safe data handling and minimal content logging.

## Target Users

### Primary audience
- **Solo professionals** (developers, freelancers): many small tasks, need a fast inbox.
- **Managers/leads**: daily list, overdue control, focus on what’s urgent.
- **Students**: deadlines and regular reminders.

### Key user needs
1. Capture a task in one step.
2. Manage tasks by status (todo/doing/done).
3. See “today” and overdue items.
4. Receive reminders and react quickly (complete/reschedule).
5. Find tasks by text/tag.

## Goals & Success Metrics

### Product Goals
- Make task capture simpler and reduce “leaks” (forgotten tasks).
- Provide daily control: today/overdue/doing.
- Improve completion via reminders and quick actions.

### Success Metrics (examples)
### Success Metrics (examples)
- **Activation**: ≥1 task created within the first 5 minutes after `/start`.
- **Retention D7**: share of users active on day 7.
- **Task completion rate**: share of tasks moved to `done`.
- **Reminder effectiveness**: share of reminders after which the task is completed/rescheduled within 24 hours.

## MVP Scope

### ✅ In Scope — Core Functionality

**Tasks:**
- Create a task: `/add <text>` (minimum: title).
- Statuses: `todo`, `doing`, `done` (optional: `inbox`, `archived`).
- Priority: `low / normal / high`.
- Deadline: set/unset date/time.
- Tags: add/remove (minimum: list of tags per task).

**Lists & search:**
- `/list` (default: today + overdue + doing).
- Quick lists: `/todo`, `/doing`, `/done` (and/or buttons).
- Search: `/search <query>` (minimum: title; optional: tags).
- Pagination (“show more”) for long lists.

**Reminders:**
- Remind before deadline (configurable per user).
- Quiet hours or a time window for sending reminders.
- Inline reminder actions: Done / snooze (reschedule) / open task.

**Export:**
- Export tasks to chat (text) and/or `.csv`.

### ✅ UX / Telegram Interface

**Entry points:**
- `/start`: greeting + 2–3 tips + an `/add` example.
- (Optional) plain text: offer to create a task from a message.

**Core commands (proposal):**
- `/add <text>` — create a task
- `/list` — overview
- `/todo` `/doing` `/done` — quick lists
- `/task <id>` — task card
- `/search <query>` — search
- `/settings` — timezone & reminders
- `/help` — help

**Task card (message + inline buttons):**
- Fields: title, status, priority, due_at, tags, created/updated, (opt.) description
- Inline buttons (MVP):
  - ✅ Done
  - ▶️ Doing / 📝 Todo
  - ⏰ Set deadline (options: today/tomorrow/manual input)
  - ➕1d (if due_at is set)
  - 🏷 Tags
  - 🗑 Delete (with confirmation) or Archive

### ❌ Out of Scope (not MVP)
- Team collaboration (shared lists/assignment/permissions).
- Complex recurrence (RRULE), dependencies, charts.
- Integrations (Notion/Jira/Trello/Calendar) — backlog.
- Full NLP date parsing (“next Monday 6pm”) — later.

## Functional Requirements

### Tasks
- FR-1: Create a task with at least: `id`, `telegram_user_id`, `title`, `status`, `created_at`.
- FR-2: Change a task status.
- FR-3: Set/unset a deadline.
- FR-4: Set priority.
- FR-5: Add/remove tags.
- FR-6: Return task lists with filters (status, today, overdue).

### Reminders
- FR-7: Schedule and send reminders according to user preferences.
- FR-8: Do not send reminders during quiet hours (or respect a time window).
- FR-9: Support reminder actions: done / snooze (reschedule) / open task.

### Settings
- FR-10: Store user timezone.
- FR-11: Store and apply reminder preferences (e.g., N minutes/hours before; morning of due date).

### Export
- FR-12: Export tasks (text/CSV).

## Non-Functional Requirements

- NFR-1: **Secrets** — store tokens/secrets only via env/.env (never in the repository).
- NFR-2: **Error handling** — do not show users tracebacks; provide friendly error messages.
- NFR-3: **Performance** — `/list` and task cards respond in ~1–2 seconds under normal load.
- NFR-4: **Scalability** — storage supports growth to tens of thousands of tasks.
- NFR-5: **Timezone correctness** — correct timezone handling.
- NFR-6: **Logging** — event logging without storing private message content (or with minimization).

## Data Model (Draft)

### Entities
- **User**
  - `telegram_user_id` (unique)
  - `timezone`
  - `reminder_prefs`
  - `created_at`, `updated_at`
- **Task**
  - `id` (int/uuid)
  - `telegram_user_id`
  - `title`
  - `description` (optional)
  - `status` (enum)
  - `priority` (enum)
  - `due_at` (datetime, optional)
  - `tags` (array / m2m)
  - `created_at`, `updated_at`, `completed_at` (optional)
- **Reminder**
  - `id`
  - `task_id`
  - `scheduled_at`
  - `sent_at` (optional)
  - `state` (scheduled/sent/cancelled)

### Business Rules
- A `done` task must not trigger reminders (all future reminders are cancelled).
- “Overdue” = `due_at < now` and status is not `done` (and not `archived`, if used).

## Analytics / Events

Events (without private text):
- `user_started`
- `task_created`
- `task_completed`
- `task_deadline_set`
- `reminder_sent`
- `reminder_action_done`
- `reminder_action_snooze`

## Risks & Edge Cases

- No timezone set → incorrect deadlines/reminders.
- Task flooding → per-user rate limiting.
- Very long lists → pagination / “show more”.
- Accidental deletion → confirmation and/or Archive instead of Delete.

## Acceptance Criteria (MVP)

- The user can:
  - create a task via `/add`
  - see `/list` overview with today/overdue
  - open `/task <id>` and switch status (including done) via inline button
  - set a deadline and receive a reminder
  - filter tasks by status
  - export tasks (text/CSV)
- No secrets are stored in the repository; everything is via env/.env.
- Telegram API errors do not “crash” the chat flow; the user sees a clear message.

## Roadmap (Post‑MVP Backlog)

- Projects/lists (work/personal) and quick switchers.
- Recurring tasks.
- Shared lists (sharing).
- Integrations: Google Calendar, Notion, Jira.
- Smarter natural-language deadline parsing.

---

**Document Version:** 1.1  
**Created:** March 7, 2026  
**Updated:** March 7, 2026  
**Status:** MVP PRD (structure aligned to reference PRD style)  



