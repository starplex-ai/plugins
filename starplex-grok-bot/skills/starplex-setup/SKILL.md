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

The steps run the CLI as `<cli>`. That is the full path of the CLI command
step 0 finds working on this computer: `$HOME/.local/bin/starplex-bot` when
this plugin installed it, or an earlier working one, such as the command an
existing Starplex connector runs. Use the same command for every step.

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
  report. Starting again means, in this order and each only after a yes: the
  person removes the Starplex connector in Connect apps; you stop its
  `starplex.js mcp` processes by PID; you delete `$HOME/.local/bin/starplex`
  (if step 0 found it is the person's own wrapper, say so and ask about it
  separately),
  `$HOME/.local/bin/starplex-bot`, `$HOME/.local/share/starplex`,
  `$HOME/.config/starplex`, `$HOME/.config/starplex-launcher`,
  `$HOME/.local/state/starplex-launcher` and the folder's `.starplex`; you
  move aside the skill copies step 0 found that Starplex didn't install (see
  "Moving a skill copy aside"); and the person deletes the hand-made Starplex
  skills step 0 found in the app. Then work through steps 1 to 5.
  Afterwards, don't ask the person to revoke the old sign-in: deleting
  `$HOME/.config/starplex` removed the bot's copy, and the old connection
  ends by itself after 30 days unused. Say only this one line about it:
  "Your old sign-in will expire by itself after 30 days unused. If you'd
  like to remove it sooner, you can revoke it on
  https://app.starplex.dev/connections (the older Starplex CLI row)."

## 0. Take stock

Change nothing in this step. Find and list for the person:

- skills in the app whose name or description mentions Starplex, other than
  this plugin's (`starplex`, `starplex-setup`, `starplex-documentation`,
  `starplex-harnesses`, `starplex-incident`, `starplex-rca`);
- connectors mentioning Starplex, with each one's command or address;
- whether `STARPLEX_TOKEN` is set as a secret or environment variable (yes
  or no, never its value);
- every `starplex` or `starplex-bot` file in `$HOME/.local/bin` and on
  `PATH` (`command -v starplex starplex-bot`), what each prints for
  `--version`, and whether `$HOME/.local/bin/starplex` is the standard
  installer's file (it contains the line "This file stays as the install
  wrote it") or someone's own wrapper;
- running `starplex.js mcp` processes (`ps -eo pid,lstart,args | grep
  'starplex.js mcp'`), with each one's PID, start time and working folder;
- whether the connector's folder (usually `/workspace`) has
  `.starplex/project.json`, and the `release_number` in its
  `.starplex/installed-packages.json`;
- skill copies in that folder that Starplex didn't install, and skills the
  installer skipped. Starplex installs each skill in `.agents/skills/` and
  `.claude/skills/` as a link into `.starplex/package-store/current/skills/`.
  When a folder or file with the same name is already there, the installer
  leaves it alone, skips that skill and lists it under `"skipped"` in
  `installed-packages.json`, so the bot keeps reading the old copy. Run this
  in the connector's folder; it only reads:

  ```sh
  for b in .agents/skills .claude/skills; do
    [ -d "$b" ] || continue
    for d in "$b"/*; do
      [ -e "$d" ] || [ -L "$d" ] || continue
      case "$(readlink "$d" 2>/dev/null)" in
        ../../.starplex/package-store/current/skills/*) ;;
        *) echo "not installed by Starplex: $d" ;;
      esac
    done
  done
  grep '"skipped"' .starplex/installed-packages.json 2>/dev/null
  ```

  A copy whose name starts with `starplex`, or that appears in a
  `"skipped"` list, is in the way. Any other copy is the person's own skill:
  mention it and leave it alone. Every `"skipped"` line should read
  `"skipped": []`.

Then choose `<cli>`: the command a Starplex Command connector runs, if it
prints a version (resolve a bare `starplex` with `command -v`); otherwise
`$HOME/.local/bin/starplex-bot`, if it prints a version; otherwise none yet,
and step 1 installs it. A wrapper the person made, for example one that
runs the CLI with its own Node 26, counts as working when it prints a
version. Keep using it, and don't install a second CLI beside it.

Sort what you find into two groups:

- **Working, keep:** `<cli>`, one Command connector that runs it with `mcp`
  whatever its name, and this plugin's skills.
- **Broken or extra:** for example a hand-made Starplex skill in the app, a
  skill copy in the folder that is in the way, a second Starplex connector,
  a connector that uses a token, a CLI command that doesn't print a
  version, or `starplex.js mcp` processes started long before the current
  connector. List each one, say what it is, and remove nothing until the
  person says yes to that item.

Hand-made Starplex skills in the app must go: name each one and ask the
person to delete it under **Connect apps**, because the bot can't tell
which `starplex` skill to follow when two exist. If the app offers no way
to delete one (a skill "From this Bot's template" may not), read its
instructions: it does no harm if it only says to read and follow
`/workspace/.agents/skills/starplex/SKILL.md`; otherwise tell the person
setup can't finish while it remains, and stop.

The person removes skills and connectors in the app under **Connect apps**.
Removing a connector doesn't stop its `starplex.js mcp` processes, so stop
those by PID once the person says yes.

### Moving a skill copy aside

For a copy in the folder that is in the way, ask the person, and after a
yes move it to a dated backup folder outside the skills folders rather than
deleting it, for example:

```sh
backup="$HOME/starplex-skill-backup-$(date +%Y%m%d)"
mkdir -p "$backup/agents" "$backup/claude"
mv /workspace/.agents/skills/<name> "$backup/agents/"
```

(use `"$backup/claude/"` for a copy in `.claude/skills`). Tell the person
where it went. Then restart the connector as "Skills are out of date" says,
so the installer puts Starplex's copy in its place.

If `STARPLEX_TOKEN` is set, say so, but don't ask the person to revoke a
token or delete the secret. A personal bot can't delete a saved secret, and
you can't tell which token it holds. The CLI uses it only when no sign-in is
saved, so once step 2 has saved a sign-in it goes unused.

## 1. The CLI

Check: step 0 found a `<cli>` that prints a version. If it did, go to
step 2. An update request never installs the CLI: the CLI updates itself.

Otherwise, show the person `scripts/install.sh` from this skill's folder,
say in two lines what it does (installs Node 26 beside any existing Node,
installs the Starplex CLI, and makes a `starplex-bot` command that runs it
with Node 26), and wait for their OK. If they decline, stop. Then run it with `sh` and tell them the
last line it prints. Ignore the installer's suggestion to run `starplex login`
or `starplex setup-mcp`: the next steps replace them here. If it fails, give
the person the exact output, then stop; don't continue to step 2. Running it
again is safe. It stops without changing anything if
`$HOME/.local/bin/starplex` exists and the Starplex installer didn't write
it: tell the person, and don't move or delete that file without their yes.
Once it succeeds, `<cli>` is `$HOME/.local/bin/starplex-bot`.

To report which build is installed, read `commit` and `sequence` from the
`build.json` in the CLI's current version folder. Don't use folder dates:
they change when the CLI retires an old build, not only when it downloads
one.

## 2. Sign-in

Check: `<cli> auth-check` reports that you are
signed in. If it does, go to step 3, unless `STARPLEX_TOKEN` is set: then
run `login --device-code` even when auth-check passes, because without a
saved sign-in the CLI falls back to the token, and revoking the token would
break Starplex.

Otherwise run `<cli> login --device-code` and keep
it running. Give the person the web address and code it prints straight
away, and tell them:

- open the address on their own phone or laptop and type the code;
- untick every organization this bot should not reach;
- leave **Also let it change your account** unticked.

A code lasts ten minutes. If it expires, run the command again. If the
person declines, or login fails for another reason, report it and stop. Report when
the command finishes; don't repeat any output line that mentions a token.

## 3. The folder link

The connector keeps Starplex's skill files up to date only in a folder
linked to a project. A Grok Bot's folder, usually `/workspace`, isn't a git
repository, so it needs linking here, before the connector is added, so the
connector's first start finds it.

Use the connector's folder from step 0 (usually `/workspace`); the commands
below show `/workspace`.

Check: `/workspace/.starplex/project.json` exists. If it does, go to step 4.

Otherwise ask the person which project this bot works on, as
`<organization>/<project>`: both are in the project's web address on
app.starplex.dev. Then run:

```sh
<cli> link-project --folder /workspace --for-project <organization>/<project>
```

It should exit 0 and say the folder is set up for that project. If not,
quote the error, check the `<organization>/<project>` with the person, and
stop.

## 4. The connector

Check: you have Starplex tools such as `list_projects`. If you do, and you
linked the folder in step 3 just now, the connector started before the link
existed: follow "Skills are out of date" below, then go to step 5. If you
have them and the folder was already linked, go to step 5. Keep the
connector that gives you the tools, whatever it is named; never add a
second one beside it.

The tools come from a custom Command connector on this computer, not from a
plugin in the catalog: the Starplex plugin holds only skills, so don't look
for a connector there. Give the person the full path of `<cli>` (expand
`$HOME`) and these steps:

1. In the Grok Bot desktop app, choose **Connect apps** (the grid icon with a
   plus sign near the bottom of the sidebar).
2. Scroll to the bottom and choose **Add a custom connector**.
3. Name `Starplex tools`, type Command, command the full path, arguments
   `mcp`, then **Add plugin**.

If you can add a connector yourself, do it with those values instead. It
shows Starting, then Connected; this can take a few minutes. It may show
Error ("Failed to load connector. Details: MCP server exited") straight
after it is added and then change to Connected by itself within a minute.
If it still shows Error after a minute, make one Starplex call; if that call
fails, quote the error to the person and stop. If it isn't Connected after
10 minutes, report its status to the person and stop. Don't add a
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
  and the `release_number` in `/workspace/.starplex/installed-packages.json`;
- step 0's skill check, run again now, prints no copy in the way and every
  `"skipped"` line reads `"skipped": []`;
- no hand-made Starplex skill remains in the app, apart from one the app
  won't delete that only points at the folder's `starplex` skill.

If the tools can't read the project, run `<cli> auth-check`: if it
says `not_signed_in`, repeat step 2; otherwise ask the person to check that
https://app.starplex.dev/connections covers that organization.

## Skills are out of date

The connector fetches skills only when it starts. On a bot set up without
the folder link, or whose connector has been running since before a new
release, the skills stay old. A skill also stays old when a copy Starplex
didn't install sits in its place: the installer skips it, with no warning
line.

1. Make sure the folder is linked (step 3), and move aside any copy step 0's
   skill check finds in the way (see "Moving a skill copy aside").
2. Restart the connector by stopping its processes. Removing and re-adding
   the connector in Connect apps doesn't do this: the old process keeps
   running. List them with `ps -eo pid,lstart,args | grep 'starplex.js
   mcp'`, show the person, and stop only those PIDs, only after the person
says yes. Don't stop anything
   by name or pattern.
3. Make one Starplex call so Grok Bot starts a fresh connector, then run
   step 5's check. If no new `starplex.js mcp` process appears, report it to
   the person and stop. If the warning appears again after one restart,
   quote it and stop.

After you stop the processes, Connect apps shows the connector as Error
("MCP server exited", 0 tools) until the next Starplex call starts a new
one. Then it shows Connected again. Tell the person this is expected.

Leftover connector processes from a removed connector can still act with
the saved sign-in until they are stopped. Stopping them by PID is enough.
Revoking that sign-in on https://app.starplex.dev/connections also cuts
them off, but it is optional, and it signs out every process using it.
