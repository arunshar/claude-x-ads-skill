# Emergency stop

Use this page when an ad is running and you want it to stop now. The steps go from fastest to most complete. Each one works on its own.

## 1. Switch the campaign off in Ads Manager

1. Open [ads.x.com](https://ads.x.com) and sign in.
2. Find the campaign in the campaigns list.
3. Switch it off with its toggle, or pause it from its menu.

This works even if Claude Code is closed or your sign-in has expired. It is the control X itself provides, so use it first when you are unsure.

## 2. Ask Claude to pause

```text
Pause campaign camp01 and line item line01 now.
```

Use your own IDs or the campaign's name. Pausing never needs approval. Claude pauses both objects and reads their status back. If Claude reports an error, go back to step 1.

## 3. Cut Claude off from your ads account

Do this if you no longer want Claude to reach the account at all.

1. **Revoke the app in X:** In your X account settings, open the security and account access section, find the list of connected apps, and revoke your developer app. The exact menu names can change.
2. **Remove the server from Claude Code:**

```bash
claude mcp remove x-ads
```

3. **Optional:** In the X Developer Console, regenerate the app's keys or delete the app.

Revoking access does not pause a running campaign. Pause it first with step 1 or step 2.

## 4. Limit the damage at the card

- Remove the card from Ads Manager, or lower its limit with your card provider. X may still bill what was already delivered.
- Check the billing page in Ads Manager for the final charge. Stats in the API can lag.

## What stops spending even if you do nothing

The skill sets two limits on X's side for every campaign it builds:

- The line item has a total budget.
- The line item has an end time.

It is not known whether X can bill slightly past a budget, so treat these as strong limits and not as guarantees. A low-limit card is the backstop that does not depend on X or on Claude.
