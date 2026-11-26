# 02 Developer Console app

Claude Code signs in to X through an app that you own. This page sets up that app. You do every step on this page yourself, in your own browser.

X's own instructions are on the [X Ads MCP page](https://docs.x.com/x-ads-api/mcp), under "Step One". The screens below are what the console showed in November 2026, and X can change them.

## Create or choose the app

1. Sign in at [console.x.com](https://console.x.com) with the X account that will run the ads.
2. Accept the Developer Agreement if the console asks. Read it first.
3. Create an app, or pick an existing app that no other tool uses.

**Why a dedicated app:** X keeps one live OAuth grant per app and user. If two tools sign in through the same app, each sign-in cancels the other tool's tokens. Give Claude Code its own app.

## Turn on OAuth 2.0

1. Open the app and go to **Keys & Tokens**.
2. Find **User authentication settings** under "OAuth 2.0 keys" and click **Set up**.
3. Fill in the form:

| Field | Value |
| :- | :- |
| App permissions | Read and write |
| Type of app | Native app (public client) |
| Callback URI / redirect URL | `http://localhost:8080/callback` |
| Website URL | `http://x.com` |
| Request email from users | off |

4. Leave the optional fields blank and click **Save changes**.

**App permissions:** Pick "Read and write". The option that adds direct messages gives the app more access than this tutorial needs.

**Type of app:** X's docs say Claude Code needs a public client, which is the "Native app" choice.

**Callback:** Type it exactly. Use `localhost`, not `127.0.0.1`.

## Copy the Client ID

After you save, the console shows an **OAuth 2.0 Client ID**. It is a long string of letters and digits.

- The Client ID is a public identifier. You will paste it into one command on [page 04](04-connect-claude-code-and-desktop.md).
- The numeric app ID near the app name is a different value. Do not use it.
- The console may also show a **Client Secret**. Do not paste it into Claude, a file or a screenshot. Claude Code does not need it. If it is ever exposed, regenerate it on the same page.
- You do not need a Bearer Token, a Consumer Key or an Access Token for this tutorial. Leave those buttons alone.

## Give the app Ads API access

X's docs describe this step as **Project Access**, **MANAGE**, **Ads Project**. In November 2026 the console showed it differently:

1. Next to **API access** on the app page, click **Manage**.
2. Find the Ads entry. It appeared as an **Ads** plan tagged "MCP access only" on the Access page, and as **Ads Starter** with Connect buttons in the app's API access dialog.
3. Read any terms or pricing the console shows, then start or connect the plan.
4. Check that the Ads entry now shows as connected.

**Unverified:** The Connect buttons named three environments (Development, Staging, Production), and X's docs do not explain them. One tested app worked after it was connected.

**Unverified:** X's older [step-by-step guide](https://docs.x.com/x-ads-api/getting-started) says each app must be approved through an Ads API Access Form. The newer MCP page says the console step is enough. If Claude's first call returns a `403` that does not mention a scope, your app is probably not enrolled yet, and you may need that form.

## Check your work

You are done with this page when all of these are true:

- The app type is Native app (public client).
- The callback is exactly `http://localhost:8080/callback`.
- You have the OAuth 2.0 Client ID copied.
- The app's API access shows the Ads plan as connected.

Next: [03 Ads account and card](03-ads-account-and-card.md)
