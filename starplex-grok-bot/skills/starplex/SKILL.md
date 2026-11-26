---
name: starplex
description: Use for any Starplex work: reading or writing Starplex items, planning, building or reviewing a change, or when the person mentions Starplex, an item reference such as SP-123, or their project's tickets.
---

# Starplex

Starplex keeps a project's work as items: each one holds the intent, the
decisions, the changes and the reviews. This skill only tells you where
Starplex's real instructions are. It holds no process rules of its own.

## Before any Starplex work

1. Check that you have the Starplex tools (for example `list_projects`). If
   you don't, use the `starplex-setup` skill first.
2. Read Starplex's current skill. The Starplex connector copies it into the
   folder the connector runs in, at `.agents/skills/starplex/SKILL.md`. Find
   that file and read it, then read the files beside it that it names for the
   item's state. If you can't find it, ask the person which folder the
   connector uses rather than working without it.
3. Follow that skill. Where it and this file differ, it wins.

## Two rules that hold even before you have read it

- Work starts from an item. If the person asks for a change with no item,
  find the item it belongs to or ask before filing one. Don't start work
  that no item records.
- Don't write or build code on this computer. It isn't set up to build and
  review code the way Starplex requires. Hand building to a route the person
  has set up, such as their own server
  (https://docs.starplex.dev/home-server), and tell them if none exists.

Never print a token, a sign-in code's secret or any credential value.
