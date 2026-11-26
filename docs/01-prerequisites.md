# 01 Prerequisites

This page lists what you need before you start, what it may cost, and how long it takes.

## What you need

- **Claude Code 2.1.332 or later:** The skill was tested on this version. Run `claude --version` to check. The `claude mcp add` command must support `--client-id` and `--callback-port`, which you can confirm with `claude mcp add --help`.
- **An X account:** This is the account that will own the ad. It needs at least one public post to promote, or you can let Claude create a promoted-only post after you approve its text.
- **An X developer account and app:** You create these in the [X Developer Console](https://console.x.com). [Page 02](02-developer-console-app.md) covers the settings.
- **An X Ads account with a card:** You set this up at [ads.x.com](https://ads.x.com). [Page 03](03-ads-account-and-card.md) covers it.
- **A free local port:** The sign-in uses `http://localhost:8080/callback`, so port 8080 must be free during sign-in.

## What it may cost

- **The ad spend:** You choose the cap. The tutorial uses 1.00 in your account's currency.
- **X API plans (unverified):** In November 2026 the tested app was on a pay-per-use X API plan and an Ads plan labeled "MCP access only". It is not known whether X bills API fees for Ads MCP calls. Read the pricing the console shows you, and check its usage page after your test.
- **Claude usage:** A full run is a few dozen tool calls and uses your normal Claude plan or API credit.

## How long it takes

- **Setup:** The first setup takes about an hour, and most of it happens in X's console and Ads Manager.
- **Account review:** A new ads account goes through X's review before its first ad can serve. In one case this took about two hours, and X sent an email when it finished.
- **Ad review:** Each ad is reviewed too. One ad was accepted in about an hour, and another stayed under review for several hours.

## What you do, and what Claude does

**You do these yourself, every time:**
- You sign in to X, the developer console and Ads Manager, including any 2FA step.
- You accept the Developer Agreement and any plan terms.
- You enter your card details.
- You approve X's OAuth consent screen.
- You decide on any promotional offer X shows you.
- You reply `yes, launch` to a spend card.

**Claude does these:**
- It runs the `claude mcp add` command with the Client ID you give it, if you ask.
- It reads your ads account, funding source, campaigns and posts.
- It builds the campaign paused, reads it back and shows you the spend card.
- It launches after your `yes, launch`, and it checks status and pauses when you ask.

## Eligibility

X decides who can advertise and where. Read X's [eligibility page](https://business.x.com/en/help/ads-policies/campaign-considerations/about-eligibility-for-x-ads) and its [ads policies](https://business.x.com/en/help/ads-policies) for your country and your type of content before you spend.

**Unverified:** X's policy site blocks automated readers, so this tutorial could not quote the eligibility page. A search summary of that page says an account must be verified through one of X's programs for individuals or businesses. Check the page yourself.

This tutorial was tested with one account that bills in USD.

Next: [02 Developer Console app](02-developer-console-app.md)
