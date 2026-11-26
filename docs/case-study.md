# Case study: a first run, and what it taught

This page describes the first real campaign run with this skill, in November 2026. It is the author's own account, with identifiers removed. Times are given as hours and minutes after the first build.

**Status:** The final numbers were not available when this page was written. They will be added later.

## The goal

The goal was to boost one existing post for 24 hours with a 1.00 USD cap, driven entirely from Claude Code, with a human approval before any spend.

## Timeline

| Time | What happened |
| :- | :- |
| Day before | The developer app got OAuth 2.0 settings and the Ads plan. The server was added to Claude Code with read-only scopes. A read-only preflight listed the account, the card, the older campaigns and the recent posts. |
| 0:00 | With write scope and an approved draft, Claude built the campaign, the line item, the country targeting and the ad. All read back as paused. |
| 0:02 | The user replied `yes, launch` to the spend card. Claude activated both objects, with a start time several hours out. |
| 0:26 | The user asked to start sooner. After a second card and a second `yes, launch`, Claude moved the flight to start a few minutes later. |
| 0:32 | A status check found the ad rejected. Its status had changed from accepted to rejected about 30 seconds after it was attached. Claude paused both objects before the start time. Nothing served. |
| 0:38 | The campaign became active again, and Claude had made no such call. A check found it ten minutes later, and Claude paused it again. The cause was never identified. |
| 1:06 | Claude's first attempt to create a promoted-only copy of the post failed, because the text with its full link was over 280 characters. A shorter link fixed it. |
| 1:08 | Claude attached the copy, which had no hashtag, and a second post the user chose. Both went under review, and the campaign listed the account as under review. |
| About 3:30 | X emailed that the ads account was approved. One ad was accepted. The copy was still under review. |
| 3:50 | The user chose to launch the accepted ad alone. Claude removed the other ad, showed a fresh card, and launched after `yes, launch`. The campaign read as running. |
| 5:35 | After another card and another `yes, launch`, Claude attached the copy again to the running line item, sharing the same cap. It went back under review. |
| 6:07 | A status check showed the campaign running, one ad accepted, one under review, and no impressions or charge recorded yet. |

## What went wrong, and the lesson

**Instant rejection:** X rejected the ad within seconds. The post had a hashtag. Earlier ads on the same account that had no hashtag had been accepted, and press coverage says X has banned hashtags in ads since June 2025. The API gave no reason, so this cause is likely and not confirmed. The skill now flags hashtags during the preflight.

**Hidden rejection:** The campaign's status did not show it. The campaign still listed only "starts in the future" as its reason for not serving. The rejection showed only on the ad itself. The skill now reads each ad's approval status directly.

**Early status:** "Accepted" was not final. The ad read as accepted right after it was attached. The skill now waits a few minutes and reads again before it shows a card.

**Stale scopes:** The write scope did not take effect at first. After the scopes changed, two sign-ins from an already open session kept the old read-only scopes. A fresh session fixed it. The tutorial now says to restart first.

**Account review:** A new ads account needs review. Neither the docs nor the API said how long it would take. It took about two hours.

**Outside changes:** State changed outside Claude. The campaign became active once with no call from Claude. The skill now re-reads the campaign, the line item and the ads before every launch.

**Paused review:** Removing an ad paused its review. The copy did not finish review while it was removed from the line item.

**Empty stats:** Stats were empty for hours. More than two hours after launch, X returned no impressions and no charge. The skill reports empty values as empty and does not treat them as zero.

## What worked

- **Paused by default:** Every object was created paused, on every attempt.
- **The exact phrase:** The user replied "approved" once and "please proceed" once. Claude asked for `yes, launch` both times and launched nothing until it got it.
- **Early launch replies:** The user sent `yes, launch` twice before any spend card existed. Claude treated neither as approval.
- **Free pauses:** Claude paused the campaign twice without asking, which is what the rules allow, and no ad served before the problems were fixed.
- **Read-only checks:** Most of the investigation used only read tools.

## Numbers

| Measure | Value |
| :- | :- |
| Total budget cap | 1.00 USD |
| Spend-card approvals given | 4 |
| Ads rejected | 1 |
| Ads accepted | 1 when this page was written |
| Charge recorded by X when this page was written | none |

Final impressions, engagements and the billed charge will be added later.
