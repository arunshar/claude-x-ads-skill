# Connect X Ads to Claude Code through X's official Ads MCP

This guide was checked against X's docs in November 2026 and tested on Claude Code 2.1.332. Each step names its source. Anything that could not be confirmed from a primary page is marked **Unverified**. X can change its console and its server at any time, so trust what you see on screen over this page.

**Sources:**
- [X Ads MCP](https://docs.x.com/x-ads-api/mcp) (setup, scopes, the Claude Code recipe)
- [X Ads MCP API Reference](https://docs.x.com/x-ads-api/mcp/reference) (the tools and their Ads API routes)
- [Ads API step-by-step guide](https://docs.x.com/x-ads-api/getting-started) (developer account, Ads API access form)
- [Campaign management overview](https://docs.x.com/x-ads-api/campaign-management) and [reference](https://docs.x.com/x-ads-api/campaign-management/reference) (funding instruments, budgets, line item fields)
- [Accessing ads accounts](https://docs.x.com/x-ads-api/fundamentals/accessing-ads-accounts) (account roles)
- [Developer Agreement](https://docs.x.com/developer-terms/agreement), [Developer Policy](https://docs.x.com/developer-terms/policy), [Automation Rules](https://help.x.com/en/rules-and-policies/x-automation)

## What the user does themselves

Claude must not do any item on this list. Each one needs the user at the keyboard.

1. **Sign-ins:** Sign in to console.x.com and ads.x.com as the X account that owns the ads account. Complete any 2FA prompt.
2. **Developer Agreement:** Read and accept the X Developer Agreement and Developer Policy when the console asks.
3. **Payment method:** Add a credit card at ads.x.com. X's docs say card funding instruments must be set up at ads.x.com, and the API cannot create them.
4. **Advertiser offers:** Decide on any promotional offer yourself. A new advertiser may see an offer that asks for a spend commitment in return for credits. A small test does not need it.
5. **API plans:** Start or connect any plan the console requires, and read its terms and pricing first.
6. **OAuth consent:** Run `/mcp` in Claude Code, pick the server, and approve X's consent screen in the browser.
7. **Spend approvals:** Give a fresh `yes, launch` in chat before any launch. See `SKILL.md` for the gate.

The OAuth 2.0 Client ID is a public identifier, so it is fine to paste into the `claude mcp add` command. Never paste an access token, refresh token, client secret or card number into chat or into a file.

## Step 1: X Developer Console app

Source: X Ads MCP, "Step One".

1. Sign in at [console.x.com](https://console.x.com). Create an app, or reuse one that no other client uses.
2. Open the app's user authentication settings. In November 2026 this was a **Set up** button next to "User authentication settings".
3. Set **App permissions** to **Read and write**.
4. Set **Type of app** to **Native app (public client)**. X's docs say Claude Code needs a public client.
5. Register the callback `http://localhost:8080/callback` exactly. Use `localhost` for Claude Code.
6. Set **Website URL** to `http://x.com`, as X's page shows.
7. Save, then copy the **OAuth 2.0 Client ID**. It is a long string. It is not the numeric app ID.
8. If the console also shows a Client Secret, do not paste it anywhere. Claude Code does not use it. If it was ever exposed, regenerate it.
9. Give the app Ads API access. X's docs describe this as **Project Access**, MANAGE, **Ads Project**. In November 2026 the console showed an **Ads** plan tagged "MCP access only" and an **Ads Starter** entry with Connect buttons in the app's API access dialog.

**One grant per app:** X keeps one live OAuth grant per app and user. A sign-in from a second client revokes the first client's tokens. Use one app for one client, or make a second app.

**Unverified:** X's older step-by-step guide says each app needs approval through the [Ads API Access Form](https://docs.x.com/forms/ads-api-access). The newer MCP page says the Ads Project selection enables access automatically. It is not known which applies to a new app.

**Unverified:** The console's Connect buttons named three environments (Development, Staging, Production). X's docs do not explain them. One tested app worked after it was connected.

**Unverified:** It is not known whether X charges API fees for Ads MCP calls under a pay-per-use API plan. Check the console's usage page after a test.

## Step 2: ads account and payment method

Sources: X Ads MCP, campaign management overview, accessing ads accounts.

1. Open [ads.x.com](https://ads.x.com) as the same X user. The server shows only the ads accounts this user can reach.
2. Add a credit card as the payment method. This creates the funding instrument that `list_funding_instruments` returns.
3. Check your role on the ads account. Creating campaigns needs an administrator or ad manager role.
4. Expect a review of a new ads account. In one case X cleared the account about two hours after the first campaign was built, and sent an approval email.

**Unverified:** It is not known whether X sets a minimum budget or bid. X's reference shows a line item example with a 1.00 daily budget, which suggests the value is accepted. It does not prove that a 1.00 budget will deliver.

## Step 3: add the server to Claude Code

Source: X Ads MCP, "Claude Code".

Run this in a normal terminal. Put your own Client ID in place of the placeholder.

```bash
claude mcp add -s user x-ads https://ads-api.x.com/mcp --transport http --client-id YOUR_OAUTH2_CLIENT_ID --callback-port 8080
```

`-s user` makes the server available in every project. X's page shows the command without `-s`, which ties the server to the current folder.

If port 8080 is busy, the sign-in fails. Free the port, or register a different callback port in the console and pass the same port to `--callback-port`.

**Read-only first:** Claude Code has no command-line flag for scopes. By default it requests every scope the server advertises, which includes `ads.write`. X's page says to narrow the entry in `~/.claude.json` by adding a `scopes` value to its `oauth` object:

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

Back up `~/.claude.json` before you edit it, and change only the `scopes` line. With `-s user` the entry sits under the top-level `mcpServers`. Claude may narrow the scopes for the user after a yes, and should never print the whole file, because it holds other settings. The user widens the scopes themselves.

Always keep `offline.access`. Without it the token expires in about two hours and cannot refresh.

## Step 4: sign in and check

1. Start `claude`, run `/mcp`, select the server, and approve X's consent screen.
2. Run `claude mcp list` in a terminal. The server should show as connected.
3. Ask Claude to call `list_ads_accounts` and `list_funding_instruments`. Both are read-only.

## Step 5: widen to write scope for the build

1. The user changes `scopes` to `ads.read ads.write offline.access`.
2. Quit Claude Code and start a fresh session. A session reads the config when it starts, so a sign-in from an older session asks X for the old scopes again.
3. Run `/mcp` and authenticate again. If there is no re-authenticate option, clear the authentication first.
4. Approve the consent screen, which should now ask for permission to manage ads.

A `403` with "Missing required OAuth2 scopes: ads.write" tells you the token is still read-only. `media.write` is needed only for media uploads.

After the campaign ends, narrow the scopes back to `ads.read offline.access` and sign in again.

## Errors

- A `401` means the token is invalid or expired. Run `/mcp` and sign in again.
- A `403` with a missing-scope message means the token lacks a scope. Follow Step 5.
- A `403` without that message usually means the app is not enrolled for Ads API access. Recheck Step 1, item 9.
- If the consent screen fails right away, check that the callback is exactly `http://localhost:8080/callback` and that the app is a Native app.
- If the sign-in stops working again and again, another client may hold the grant on the same app.

## Safety facts the skill relies on

Source: X Ads MCP, "Step Three", plus the live tool schemas read in November 2026.

- `create_campaign` and `create_line_item` create objects **PAUSED**. Nothing spends until `activate_campaign` and `activate_line_item` run.
- In the live schemas, `update_campaign` and `update_line_item` listed only `PAUSED` as a status, so they can stop delivery and cannot start it. X's page states this for line items.
- The server has no delete tool for campaigns or line items. `delete_promoted_post` removes one ad from a line item, and the post stays on X.
- Budgets are in micros of the account currency. 1.00 is `1000000`.
- X's docs describe no confirmation step, dry run, spend cap or audit log on the server side. The gate in `SKILL.md` is model instructions, and it is the only gate unless the user adds a backstop.
