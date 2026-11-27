---
name: starplex-setup
description: Use when the person asks to set up, connect, repair or check Starplex on this Grok Bot, or when the starplex skill finds the Starplex tools missing.
---

# Set up Starplex on this Grok Bot

This installs the Starplex CLI on this computer, signs it in with a code the
person approves, and connects the Starplex tools. Every step is safe to run
again. Never print a token or the contents of any Starplex settings file.

## 0. Take stock of any earlier Starplex setup

Change nothing in this step. Look for, and list for the person:

- skills in the app whose name or description mentions Starplex, other than
  this plugin's (`starplex`, `starplex-setup`, `starplex-documentation`,
  `starplex-harnesses`, `starplex-incident`, `starplex-rca`);
- connectors mentioning Starplex, with each one's command or address;
- whether a `STARPLEX_TOKEN` secret or environment variable is set (yes or
  no, never its value);
- every `starplex` or `starplex-bot` file in `$HOME/.local/bin` and on
  `PATH`, and what `starplex-bot --version` prints;
- running `starplex ... mcp` processes, with their PID, start time and
  working folder;
- whether the connector's folder (usually `/workspace`) has
  `.starplex/project.json`, and the `release_number` in its
  `.starplex/installed-packages.json`.

Say what each item is and what this setup replaces it with. Remove nothing
until the person says yes, item by item. The person removes skills and
connectors in the app under **Connect apps**, and secrets under the bot's
**Secrets**. Before removing a connector, stop its `starplex ... mcp`
processes by PID once they say yes: removing a connector doesn't stop them. Keep exactly one Starplex Command connector. A
`STARPLEX_TOKEN` must go, because the CLI would use it instead of the
person's own sign-in.

## 1. Install the CLI if it is missing

Run `"$HOME/.local/bin/starplex-bot" --version`. If it prints a version, go
to step 2.

Otherwise, show the person `scripts/install.sh` from this skill's folder,
say in two lines what it does (installs Node 26 beside any existing Node,
installs the Starplex CLI, and makes a `starplex-bot` command that runs it
with Node 26), and wait for their OK. Then run it with `sh` and tell them the
last line it prints. Ignore the installer's suggestion to run `starplex login`
or `starplex setup-mcp`: the next steps replace them here.

If it fails, give the person the exact output. Running it again is safe.

## 2. Sign in with a code

Run `"$HOME/.local/bin/starplex-bot" auth-check`. If it reports that you are
signed in, go to step 3.

Otherwise run `"$HOME/.local/bin/starplex-bot" login --device-code` and keep
it running. Give the person the web address and code it prints straight
away, and tell them:

- open the address on their own phone or laptop and type the code;
- untick every organization this bot should not reach;
- leave **Also let it change your account** unticked.

A code lasts ten minutes. If it expires, run the command again. Report when
the command finishes; don't repeat any output line that mentions a token.

## 3. Connect the Starplex tools

If you already have Starplex tools such as `list_projects`, go to step 4.

The tools come from a custom Command connector on this computer, not from
a plugin in the catalog: the Starplex plugin holds only skills, so don't
look for a connector there. Give the person the full path of
`$HOME/.local/bin/starplex-bot` (expand `$HOME`) and these steps:

1. In the Grok Bot desktop app, choose **Connect apps** (the grid icon with a
   plus sign near the bottom of the sidebar).
2. Scroll to the bottom and choose **Add a custom connector**.
3. Name `Starplex tools`, type Command, command the full path, arguments
   `mcp`, then **Add plugin**.

If you can add a connector yourself, do it with those values instead. It
shows Starting, then Connected; this can take a few minutes, and the tools
may only appear in a new chat. Don't add a connector that uses a
`STARPLEX_TOKEN`. Tell the person that removing the Starplex plugin doesn't
remove this connector, and removing this connector removes the tools.

## 4. Link the connector's folder to a project

The connector updates Starplex's skills only in a folder linked to a
project. Find the folder the connector runs in (on a Grok Bot usually
`/workspace`). If `.starplex/project.json` is missing there, ask the person
which project this bot works on (list the projects the tools can reach if
they're unsure), then run:

```sh
"$HOME/.local/bin/starplex-bot" link-project --folder /workspace --for-project <organization>/<project>
```

It should exit 0 and say the folder is set up for that project. The
connector only notices on its next start: removing and re-adding it in
Connect apps doesn't restart it. Stop its running processes by PID
(`ps -eo pid,args | grep 'starplex.js mcp'`, only those) and make one
Starplex call so Grok Bot starts a fresh one.

## 5. Check

Make one Starplex call, such as reading the linked project, and read the
end of its result. A line starting "skills kept" or "Skill sync failed"
means the skills did not update: quote it to the person and fix what it
says before going on. Don't report the skills as current unless no such
line appeared after the connector's latest start.

Then tell the person the project's name and connected repositories, and
the `release_number` in `/workspace/.starplex/installed-packages.json`.

Setup is done when the tools reach only the organizations the person
approved, read the linked project, and no skills warning appeared. If they
can't, run `starplex-bot auth-check`: if it says `not_signed_in`, repeat
step 2; otherwise ask the person to check
https://app.starplex.dev/connections covers that organization.
