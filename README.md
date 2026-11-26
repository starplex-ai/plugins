# Starplex AI plugins

Plugins that give agent apps Starplex AI: a skill that points the agent at
Starplex's current instructions, and a skill that installs and connects the
Starplex CLI.

| Plugin | For | Contents |
| --- | --- | --- |
| [`starplex-grok-bot`](starplex-grok-bot) | Grok Bot | `starplex-setup`, plus one stub per Starplex skill (`starplex`, `starplex-documentation`, `starplex-harnesses`, `starplex-incident`, `starplex-rca`) that points at the copy the connector keeps current |

The repository uses Cursor's multi-plugin layout:
`.cursor-plugin/marketplace.json` lists each plugin folder.

Licensed under the [MIT licence](LICENSE).
