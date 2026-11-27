---
name: starplex-setup
description: "Use when the person asks to set up, connect, update, repair, fix, reinstall or check Starplex on this Grok Bot, or when the starplex skill finds the Starplex tools missing."
---

# Set up, check or repair Starplex on this Grok Bot

Starplex on this bot has four pieces: the Starplex CLI on this computer, its
sign-in, the bot's working folder linked to a Starplex project, and a
connector that gives the bot Starplex tools and keeps Starplex's skill files
in that folder up to date. This skill checks each piece and does only what
is missing or broken. Never print a token or the contents of any Starplex
settings file.

## What the person asked for

- **Set up or connect:** work through every step below, doing only what each
  check finds missing.
- **Update or check:** run each step's check and report what is current and
  what is behind. Change nothing. Offer each fix and wait for a yes. The CLI
  updates itself, and the connector fetches new skills when it starts, so an
  update request is usually a report that everything is current.
- **Repair or fix:** run each check, then fix only what failed.
- **Reinstall:** run the checks first and show what is already working. Start
  again from nothing only if the person still wants that after seeing the
  report.

## 0. Take stock

Change nothing in this step. Find and list for the person:

- skills in the app whose name or description mentions Starplex, other than
  this plugin's (`starplex`, `starplex-setup`, `starplex-documentation`,
  `starplex-harnesses`, `starplex-incident`, `starplex-rca`);
- connectors mentioning Starplex, with each one's command or address;
- whether `STARPLEX_TOKEN` is set as a secret or environment variable (yes
  or no, never its value);
- every `starplex` or `starplex-bot` file in `$HOME/.local/bin` and on
  `PATH`, and what `"$HOME/.local/bin/starplex-bot" --version` prints;
- running `starplex.js mcp` processes (`ps -eo pid,lstart,args | grep
  'starplex.js mcp'`), with each one's PID, start time and working folder;
- whether the connector's folder (usually `/workspace`) has
  `.starplex/project.json`, and the `release_number` in its
  `.starplex/installed-packages.json`.

Sort what you find into two groups:

- **This setup, working:** the CLI at `$HOME/.local/bin/starplex-bot`, one
  Command connector named `Starplex tools` that runs it with `mcp`, and this
  plugin's skills. Keep these.
- **Broken or from somewhere else:** for example a hand-made Starplex skill,
  a second Starplex connector, a connector that uses a token, another copy
  of the CLI, or `starplex.js mcp` processes started long before the current
  connector. List each one, say what it is, and remove nothing until the
  person says yes to that item.

The person removes skills and connectors in the app under **Connect apps**.
Removing a connector doesn't stop its `starplex.js mcp` processes, so stop
those by PID once the person says yes.

If `STARPLEX_TOKEN` is set, tell the person to revoke that token on
https://app.starplex.dev/connections. A personal bot can't delete a saved
secret, and the CLI uses the token only when no sign-in is saved, so once
step 2 is done and the token is revoked it can do nothing.

## 1. The CLI

Check: `"$HOME/.local/bin/starplex-bot" --version` prints a version. If it
does, go to step 2.

Otherwise, show the person `scripts/install.sh` from this skill's folder,
say in two lines what it does (installs Node 26 beside any existing Node,
installs the Starplex CLI, and makes a `starplex-bot` command that runs it
with Node 26), and wait for their OK. Then run it with `sh` and tell them the
last line it prints. Ignore the installer's suggestion to run `starplex login`
or `starplex setup-mcp`: the next steps replace them here. If it fails, give
the person the exact output. Running it again is safe.

To report which build is installed, read `commit` and `sequence` from the
`build.json` in the CLI's current version folder. Don't use folder dates:
they change when the CLI retires an old build, not only when it downloads
one.

## 2. Sign-in

Check: `"$HOME/.local/bin/starplex-bot" auth-check` reports that you are
signed in. If it does, go to step 3.

Otherwise run `"$HOME/.local/bin/starplex-bot" login --device-code` and keep
it running. Give the person the web address and code it prints straight
away, and tell them:

- open the address on their own phone or laptop and type the code;
- untick every organization this bot should not reach;
- leave **Also let it change your account** unticked.

A code lasts ten minutes. If it expires, run the command again. Report when
the command finishes; don't repeat any output line that mentions a token.

## 3. The folder link

The connector keeps Starplex's skill files up to date only in a folder
linked to a project. A Grok Bot's folder, usually `/workspace`, isn't a git
repository, so it needs linking here, before the connector is added, so the
connector's first start finds it.

Check: `/workspace/.starplex/project.json` exists. If it does, go to step 4.

Otherwise ask the person which project this bot works on, as
`<organization>/<project>`: both are in the project's web address on
app.starplex.dev. Then run:

```sh
"$HOME/.local/bin/starplex-bot" link-project --folder /workspace --for-project <organization>/<project>
```

It should exit 0 and say the folder is set up for that project.

## 4. The connector

Check: you have Starplex tools such as `list_projects`. If you do, and you
linked the folder in step 3 just now, the connector started before the link
existed: follow "Skills are out of date" below, then go to step 5. If you
have them and the folder was already linked, go to step 5.

The tools come from a custom Command connector on this computer, not from a
plugin in the catalog: the Starplex plugin holds only skills, so don't look
for a connector there. Give the person the full path of
`$HOME/.local/bin/starplex-bot` (expand `$HOME`) and these steps:

1. In the Grok Bot desktop app, choose **Connect apps** (the grid icon with a
   plus sign near the bottom of the sidebar).
2. Scroll to the bottom and choose **Add a custom connector**.
3. Name `Starplex tools`, type Command, command the full path, arguments
   `mcp`, then **Add plugin**.

If you can add a connector yourself, do it with those values instead. It
shows Starting, then Connected; this can take a few minutes. Don't add a
connector that uses a `STARPLEX_TOKEN`. Tell the person that removing the
Starplex plugin doesn't remove this connector, and removing this connector
removes the tools.

## 5. Check

Make one Starplex call, such as reading the linked project, and read the end
of its result. A line starting "skills kept" or "Skill sync failed" means
the skills did not update: quote it to the person and follow "Skills are
out of date" below.

Setup is done only when all of these hold:

- the tools reach only the organizations the person approved and read the
  linked project;
- no "skills kept" or "Skill sync failed" line appeared after the
  connector's latest start;
- you have told the person the project's name and connected repositories,
  and the `release_number` in `/workspace/.starplex/installed-packages.json`.

If the tools can't read the project, run `starplex-bot auth-check`: if it
says `not_signed_in`, repeat step 2; otherwise ask the person to check that
https://app.starplex.dev/connections covers that organization.

## Skills are out of date

The connector fetches skills only when it starts. On a bot set up without
the folder link, or whose connector has been running since before a new
release, the skills stay old.

1. Make sure the folder is linked (step 3).
2. Restart the connector by stopping its processes. Removing and re-adding
   the connector in Connect apps doesn't do this: the old process keeps
   running. List them with `ps -eo pid,lstart,args | grep 'starplex.js
   mcp'`, show the person, and stop only those PIDs. Don't stop anything
   by name or pattern.
3. Make one Starplex call so Grok Bot starts a fresh connector, then run
   step 5's check.

Leftover connector processes from a removed connector can still act with
the saved sign-in. Revoking the sign-in on
https://app.starplex.dev/connections cuts them off as well.
