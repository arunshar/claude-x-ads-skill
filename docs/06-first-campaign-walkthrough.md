# 06 First campaign walkthrough

This page walks through one small campaign from the first prompt to launch. The IDs and names in the examples are placeholders.

Before you start, the X Ads server should be connected ([page 04](04-connect-claude-code-and-desktop.md)) and the skill installed ([page 05](05-install-the-skill.md)).

## Step 1: ask for a read-only preflight

```text
Use the x-ads-campaign skill. I want to boost this post with a 1.00 budget for 24 hours, targeted to the United States: https://x.com/yourhandle/status/1234567890
Start with the read-only preflight only.
```

**What Claude does:** It reads your ads accounts, funding sources, existing campaigns and posts, and the valid placements. It changes nothing.

**What you should see:**
- You see your ads account's name and ID, with a question asking you to confirm it is yours.
- You see your card, its currency, and whether it can fund a campaign.
- You see a list of the campaigns already in the account. Claude will leave these alone.
- You see the post you named, with its full text. Claude flags any hashtag, because X may reject ads that contain one.

Answer Claude's questions. If it flags a hashtag, see "Promoting a post without its hashtag" below.

## Step 2: switch to write access

The build needs the `ads.write` scope. If the preflight looks right, follow "Switch to write access" on [page 04](04-connect-claude-code-and-desktop.md): change the scopes yourself, start a fresh Claude Code session, and sign in again.

Do this before the draft. Approvals do not carry over to a new session, so the draft, the build and the launch should all happen in one session.

## Step 3: review the draft

In the new session, ask again:

```text
Use the x-ads-campaign skill. I want to boost this post with a 1.00 budget for 24 hours, targeted to the United States: https://x.com/yourhandle/status/1234567890
Run the preflight, then show me the draft. Do not build anything yet.
```

Claude repeats the read-only checks, shows a draft plan like this, and creates nothing yet:

| Field | Value |
| :- | :- |
| Ads account | Example Account (`abc123`), USD |
| Funding source | your card (`fund01`) |
| Campaign | `boost-test-2026-12-01`, created paused |
| Objective and product | engagements, promoted post |
| Placements | all on X |
| Bid | automatic |
| Daily budget | 1.00 USD |
| Total budget | 1.00 USD |
| Flight | a start time about two hours out, and an end time 24 hours later |
| Targeting | United States |
| Creative | the post you named |

Check every row. Ask for changes in plain words, such as "make it 12 hours" or "target Canada". When it is right, say you approve the draft.

## Step 4: Claude builds everything paused

**What Claude does:** It creates the campaign, the ad group (X calls it a line item), the targeting rule and the ad. After each step it reads the object back from X and checks that it is paused.

**What you should see:** Claude gives a short report with the new IDs, each with status `PAUSED`. A paused campaign cannot serve. Write the campaign and line item IDs down, because you need them to pause or check the campaign from another session.

If any call fails, Claude stops and shows you X's exact error. It does not retry with a bigger budget.

## Step 5: wait for ad review

X reviews each ad. An ad can show as accepted for a few seconds and then change, so Claude waits a few minutes and reads the status again.

- If the ad is accepted, Claude goes on to the spend card.
- If the ad is under review, Claude tells you and waits. Ask it to check again later.
- If the ad is rejected, Claude leaves everything paused and reports it. See [page 08](08-troubleshooting.md).

## Step 6: read the spend card

When every ad you plan to run is accepted, Claude shows a card filled from what X returned:

```text
SPEND CARD
Live now:           no
This approval covers: activate_campaign(camp01), activate_line_item(line01)
Ads account:        Example Account (abc123), currency USD
Funding source:     Card on file (fund01)
Campaign:           boost-test-2026-12-01 (camp01), PAUSED
Line item:          boost-test-2026-12-01-li (line01), PAUSED
Objective:          ENGAGEMENTS, PROMOTED_TWEETS, placements ALL_ON_TWITTER
Bid:                AUTO, bid none
Total budget cap:   1000000 micros (1.00 USD), combined maximum across line items 1.00 USD
Daily budget cap:   1000000 micros (1.00 USD)
Flight:             2026-12-01T18:00:00Z to 2026-12-02T18:00:00Z
Targeting:          LOCATION United States
Promoted post(s):   https://x.com/yourhandle/status/1234567890, approval status ACCEPTED
Stop rule:          The total budget and the end time on X's side are the limits. I check only when you ask. On a check, I pause both objects if billed spend is at 90% of the cap, the end time has passed, or a value differs from this card.
To approve the calls listed above, reply exactly: yes, launch
```

Read every line. The "This approval covers" line lists the exact calls your reply allows. The total budget and the end time are the two limits on X's side. Claude does not watch the campaign after launch unless you ask it to check.

## Step 7: launch, or do not

To launch, reply with exactly this:

```text
yes, launch
```

Here is how the gate behaves:

```text
You:     approved
Claude:  I need the exact reply "yes, launch" for this card. Nothing has launched.

You:     yes, but make it 2 dollars
Claude:  That changes the budget, so I will not launch. Here is a revised draft and a new card.

You:     yes, launch
Claude:  Launching now. I re-read the campaign, the line item and the ad first, and they match the card.
```

After a valid yes, Claude activates the campaign and then the line item, reads both back, and reports the status. A status of "scheduled" means the start time has not arrived yet. A status of "running" means X can serve the ad.

If you do not want to launch, say so. Everything stays paused, and paused objects cost nothing.

## Promoting a post without its hashtag

X cannot promote an edited copy of a post, and old posts usually cannot be edited. If your post has a hashtag, you have two choices:

- **Another post:** Pick a post that has no hashtag.
- **A promoted-only copy:** Claude shows you the exact text with the hashtag removed and waits for your approval of that text. The copy runs only as an ad. It does not appear on your profile or in your followers' timelines.

Keep the copy under 280 characters, counting any link at its full length.

Next: [07 Monitor, change, stop](07-monitor-change-stop.md)
