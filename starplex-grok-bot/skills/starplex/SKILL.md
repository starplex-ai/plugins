---
name: starplex
description: "Use when the developer asks to add or change functionality or fix bugs in a project using Starplex, even when the request mentions neither Starplex nor an item. Also use to connect a workspace to Starplex; read `connect.md` for setup and verification. Work with the developer on the current project's items, in whatever state they are in. Use when they ask to triage, groom, groom goals, design, build, ship or close an item, merge a batch of ready pull requests, bring a model into routing, place a finding, record a ruling, answer waiting feedback or developer questions, ask for context or a recap of where a Starplex session stands, say they are lost in one, or ask to wrap up or hand one over, and when they invoke /starplex. Also use when an audit or QA run proposes new items, where `reports.md` says how to record and review the proposals, and when asked for an incident record, an RCA or a postmortem in a project using Starplex, alongside the incident or rca skill, where `reports.md` says where it goes, and when asked to deliver a goal, save a delivery plan or carry one on, where `delivery.md` says how. A how-question is analysis; drive a goal or plan only when the developer asks for it to be delivered. One interactive skill for every phase, read with the developer in the room. A commissioned actor enters through starplex-commission instead and never through here."
---

# starplex

This skill's instructions are kept current by the Starplex connector, which
copies them into the folder it runs in. Read
`.agents/skills/starplex/SKILL.md` in that folder (on a Grok Bot usually
`/workspace/.agents/skills/starplex/SKILL.md`) and follow it, including the
files beside it that it tells you to read. Never rely on a copy.

If the file is missing, say so and stop rather than working without it.

If you have no Starplex tools (for example `list_projects`), use the
`starplex-setup` skill first.

Never print a token, a sign-in code's secret or any credential value.
