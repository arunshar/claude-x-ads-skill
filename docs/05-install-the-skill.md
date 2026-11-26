# 05 Install the skill

The skill is one Markdown file plus a setup reference. You can install it as a Claude Code plugin or copy it by hand. Pick one way, not both.

Read [the skill file](../skills/x-ads-campaign/SKILL.md) before you install it. It tells Claude what it may do with your ads account.

## Option A: install as a plugin

Run these two commands inside Claude Code:

```text
/plugin marketplace add arunshar/claude-x-ads-skill
```

```text
/plugin install x-ads-campaign@claude-x-ads-skill
```

Then start a new session. The skill appears under the name `x-ads-campaign:x-ads-campaign`, because plugin skills carry the plugin's name as a prefix.

**Update:** Run `/plugin marketplace update claude-x-ads-skill`, then reinstall or update the plugin from the `/plugin` menu.

**Uninstall:** Run `/plugin uninstall x-ads-campaign@claude-x-ads-skill`.

## Option B: copy it by hand

```bash
git clone https://github.com/arunshar/claude-x-ads-skill.git
```

```bash
mkdir -p ~/.claude/skills && cp -R claude-x-ads-skill/skills/x-ads-campaign ~/.claude/skills/
```

Then start a new session. The skill appears under the name `x-ads-campaign`.

**Update:** Pull the repository and copy the folder again.

**Uninstall:** Delete the folder `~/.claude/skills/x-ads-campaign`.

A hand-copied skill is yours to edit. For example, you can change the default campaign name or add a rule of your own. Keep the hard rules.

## Do not install both

If you install the plugin and also copy the folder, Claude sees two skills with nearly the same name and may pick either. Remove one.

## The skill does not add the server

Neither option connects the X Ads server. The server needs your own Client ID and your own sign-in, so you add it yourself as [page 04](04-connect-claude-code-and-desktop.md) explains.

## Check that it loaded

Start a new Claude Code session and ask:

```text
Which skills do you have for X ads?
```

Claude should name the skill. You can also ask it to "use the x-ads-campaign skill and run only the read-only preflight", which is the first step of [page 06](06-first-campaign-walkthrough.md).

Next: [06 First campaign walkthrough](06-first-campaign-walkthrough.md)
