# 03 Ads account and card

The X Ads server can only see ads accounts that your X user can reach, and it can only charge a payment method that already exists. You set up both yourself on this page.

## Open your ads account

1. Go to [ads.x.com](https://ads.x.com) and sign in with the same X account you used in the developer console.
2. Follow X's prompts to create an ads account if you do not have one. X asks for a country and a time zone, and you cannot easily change them later.

## Add a payment method

1. Add a credit card in Ads Manager. Enter the card details yourself.
2. Wait until Ads Manager shows the card as active.

X's [campaign management docs](https://docs.x.com/x-ads-api/campaign-management) say a card funding source must be set up at ads.x.com and cannot be created through the API. So Claude cannot add or change your card.

**A backstop worth having:** Use a virtual or prepaid card with a small limit for your first tests. The limit caps what any mistake can cost, whatever Claude or X does.

## Promotional offers

X may show new advertisers an offer, such as ad credits in return for a spend commitment within a set time. Read the terms and decide for yourself. A small test does not need an offer, and Claude will never accept one for you.

## Your role on the account

If the ads account belongs to someone else, you need a role that can create campaigns, such as account administrator or ad manager. X's [account access page](https://docs.x.com/x-ads-api/fundamentals/accessing-ads-accounts) lists the roles.

## Expect an account review

X reviews a new ads account before its first ad can serve. In one case:

- The first campaign listed "account under review" as a reason it could not serve.
- Each ad showed "under review" too.
- X approved the account about two hours later and sent an email that said the ads account was approved.

Nothing needs doing while you wait. You can still build the campaign paused during the review.

## Check your work

You are done with this page when all of these are true:

- You can open Ads Manager for your account.
- A card shows as an active payment method.
- You know the account's currency, because every budget in this tutorial is in that currency.

Next: [04 Connect Claude Code and the desktop app](04-connect-claude-code-and-desktop.md)
