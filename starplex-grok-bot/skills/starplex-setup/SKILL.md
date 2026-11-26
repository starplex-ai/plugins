---
name: starplex-setup
description: Use when the person asks to set up, connect, repair or check Starplex on this Grok Bot, or when the starplex skill finds the Starplex tools missing.
---

# Set up Starplex on this Grok Bot

This installs the Starplex CLI on this computer, signs it in with a code the
person approves, and connects the Starplex tools. Every step is safe to run
again. Never print a token or the contents of any Starplex settings file.

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

## 4. Check

Using the Starplex tools, list the organizations you can reach and the
projects in each. Ask the person which project to read, then tell them its
name and connected repositories.

Setup is done when you list only the organizations the person approved and
can read the project they chose. If you can't, run `starplex-bot auth-check`:
if it says `not_signed_in`, repeat step 2; otherwise ask the person to check
https://app.starplex.dev/connections covers that organization.
