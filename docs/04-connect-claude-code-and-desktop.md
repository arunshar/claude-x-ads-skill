# 04 Connect Claude Code and the desktop app

This page adds X's Ads MCP server to Claude Code, signs you in with read-only access, and explains how the Claude desktop app fits in.

X's recipe is on the [X Ads MCP page](https://docs.x.com/x-ads-api/mcp), under "Claude Code".

## Add the server

Run this in a normal terminal. Replace the placeholder with the Client ID from [page 02](02-developer-console-app.md).

```bash
claude mcp add -s user x-ads https://ads-api.x.com/mcp --transport http --client-id YOUR_OAUTH2_CLIENT_ID --callback-port 8080
```

- `-s user` makes the server available in every folder. Without it, the server belongs only to the folder you ran the command in.
- `x-ads` is the server's name on your machine. The skill's examples assume this name.
- You can ask Claude to run this command for you. The Client ID is public, so it is safe to paste into chat. Never paste a client secret or a token.

## Start with read-only access

Claude Code has no flag for OAuth scopes. By default it asks X for every scope the server offers, including write access to your ads. Narrow it before you sign in.

1. Make a backup copy of `~/.claude.json`.
2. Open `~/.claude.json` and find the `x-ads` entry under `mcpServers`.
3. Add a `scopes` line inside its `oauth` object, so the entry looks like this:

```json
"x-ads": {
  "type": "http",
  "url": "https://ads-api.x.com/mcp",
  "oauth": {
    "clientId": "YOUR_OAUTH2_CLIENT_ID",
    "callbackPort": 8080,
    "scopes": "ads.read offline.access"
  }
}
```

Change only that one line. The file holds your other Claude Code settings. You can ask Claude to narrow the scopes for you, and it should not print the rest of the file. Widen the scopes yourself.

**The scopes used here:**
- `ads.read` lets Claude read accounts, campaigns and stats.
- `ads.write` lets Claude create, change and launch campaigns.
- `offline.access` lets the token refresh. Always keep it, or the sign-in expires in about two hours.
- `media.write` is a fourth scope for media uploads. This tutorial does not use it.

## Sign in

1. Start `claude` in a terminal.
2. Type `/mcp`, select `x-ads`, and choose to authenticate.
3. Your browser opens X's consent screen. Check that it shows your X account, then approve it.
4. Back in the terminal, `/mcp` should report that you are signed in and connected.

You can confirm from any terminal:

```bash
claude mcp list
```

The `x-ads` line should say it is connected.

## Try a read-only check

Ask Claude:

```text
List my X ads accounts and my funding instruments. Read only, change nothing.
```

You should see your ads account's name and ID, and your card with `able_to_fund: true`. If you get an error, see [page 08](08-troubleshooting.md).

## Switch to write access when you are ready to build

Do this only when you are about to build a campaign.

1. Change the `scopes` line to `ads.read ads.write offline.access`.
2. Quit Claude Code and start a fresh session. This step matters. A session that was already open keeps asking X for the old scopes.
3. Type `/mcp`, select `x-ads`, and authenticate again. If you see no option to re-authenticate, clear the authentication first.
4. Approve the consent screen. It should now ask for permission to manage your ads.

After your campaign ends, change the scopes back to `ads.read offline.access` and sign in once more.

## Permission prompts

Keep Claude Code in its default permission mode for this work. Claude Code then asks you before it runs each X Ads tool.

- Allow read tools as you see fit.
- When Claude Code asks about a write tool, such as one that creates, updates or activates something, allow that one call only. Do not choose the option that stops asking for that tool.
- If you run Claude Code with permission prompts off, the skill's instructions are the only check between Claude and your card.

## The Claude desktop app

**The Code tab:** The desktop app's Code tab runs Claude Code and reads the same `~/.claude.json` and `~/.claude/skills` as the terminal. In the tested setup, a desktop Code session that started after the sign-in could call the X Ads tools and load the skill. So the steps are the same: add the server and sign in from a terminal, then start a new session in the desktop app.

**Sessions read the config at start:** A desktop or terminal session that was already open before you added the server will not see its tools. Start a new session.

**Chat-side custom connectors (unverified):** The desktop app and claude.ai also let you add custom connectors for chat. This tutorial has not tested the X Ads server there. X's docs list recipes for Claude Code, Grok Build and Grok on the web only. A connector would also need its own callback registered on the X app, and a sign-in from it would cancel your Claude Code sign-in if both use the same app.

## One app, one client

X keeps one live sign-in per app and user. If you add the same Client ID to a second tool or a second Claude configuration and sign in there, your first sign-in stops working. Use one app per tool.

Next: [05 Install the skill](05-install-the-skill.md)
