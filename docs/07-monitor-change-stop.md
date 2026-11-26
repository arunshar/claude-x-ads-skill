# 07 Monitor, change, stop

This page covers what to do after launch: checking status, changing a running campaign, pausing it, and wrapping up.

## Check status

Ask Claude at any time:

```text
Use the x-ads-campaign skill and run a read-only status check on campaign camp01 and line item line01.
```

Use your own campaign and line item IDs. In a new session Claude asks you to confirm them, because it only treats objects you name as yours.

**What you should see:**
- You see the campaign's status, and whether X can serve it.
- You see each ad's approval status.
- You see impressions, engagements and billed charge so far.

**Empty stats at first:** This is normal. In one run, stats stayed empty for more than two hours after launch on a 1.00 daily budget. X's stats lag behind delivery, and a small budget spread over a day buys very little in any one hour. Empty stats do not prove that nothing was charged. Ads Manager at ads.x.com is the place to confirm spend.

Claude checks when you ask, or at a time it tells you. It does not poll X in a tight loop.

## Show someone that your ad is running

- **Ads Manager:** A screenshot of the campaign's row shows its status, impressions and spend, straight from X. Check the screenshot for card details before you share it.
- **A status summary:** Ask Claude for a summary without IDs that you can paste into a message.
- **Timelines:** A promoted post is not guaranteed to appear in your own feed or in any one person's feed.

## Change a running campaign

Any change that can affect spending needs a new spend card and a new `yes, launch`.

| Change | What Claude does |
| :- | :- |
| Add another ad | Shows a card that names the new ad and states that the budget caps stay the same. The ad serves only after X accepts it. |
| Move the start or end time | Shows a card with the old and new times, then changes only the time fields and reads the budgets back. |
| Raise or lower the budget or bid | Shows a card with the old and new values. |
| Remove one ad | Does it without a card, because removing an ad can only reduce delivery. The post stays on X. |
| Pause | Does it at once, without a card. |

Two ads on one line item share that line item's budget. If you want each ad to have its own budget, ask Claude to build a second line item. That raises the most you can spend, so you must state the new overall cap yourself, and the card shows the combined maximum.

## Pause

```text
Pause campaign camp01 and line item line01.
```

Pausing never needs approval. Claude pauses both objects, reads them back, and reads them again a few minutes later.

**No background watching:** Claude does not watch your campaign. It acts only while a session is open and you ask it to check. On a check, it pauses both objects when any of these is true:
- The billed charge has reached 90% of your cap.
- The end time has passed.
- An ad was rejected and no accepted ad remains.
- Something does not match the spend card, such as a budget value.

The total budget and the end time on the line item are the real limits, because they work on X's side with no session open.

To start a paused campaign again, ask Claude. It shows a new spend card first.

## Wrap up

When the flight ends, ask:

```text
Use the x-ads-campaign skill and run the wrap-up step for campaign camp01 and line item line01.
```

**What Claude does:**
1. It makes sure the campaign and the line item are paused or ended.
2. It lists every campaign and line item in the account and reports any that reads as active. In the session that built the campaign, it also compares the list with the baseline it recorded at the start.
3. It reports impressions, engagements and billed charge exactly as X returned them.
4. It suggests switching the server back to read-only scopes.

**What you do:**
1. Confirm the final charge in Ads Manager.
2. Change the scopes back to `ads.read offline.access` and sign in again ([page 04](04-connect-claude-code-and-desktop.md)).

The server has no tool to delete campaigns or line items. They stay in your account as paused records, and they cost nothing.

Next: [08 Troubleshooting](08-troubleshooting.md)
