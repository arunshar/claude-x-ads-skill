# 08 Troubleshooting

Every problem on this page came up in a real run in November 2026. X can change its errors and its screens.

## Connection and sign-in

| Symptom | Likely cause | Fix |
| :- | :- | :- |
| `claude mcp list` shows "Needs authentication" | You have not signed in yet | Run `/mcp` in Claude Code, select the server, and approve X's consent screen |
| The consent screen fails right away | The callback or the app type is wrong | Check that the callback is exactly `http://localhost:8080/callback` and the app is a Native app (public client) |
| The sign-in page never returns | Port 8080 is in use | Free the port, or register another port in the console and pass it to `--callback-port` |
| `401` on a tool call | The token expired or was revoked | Sign in again with `/mcp`. Check that the scopes include `offline.access` |
| The sign-in stops working after you used another tool | A second client signed in through the same X app | Use one app per tool, then sign in again |
| Claude says it has no X Ads tools | The session started before you added the server | Start a new Claude Code session |

## Access errors

| Symptom | Likely cause | Fix |
| :- | :- | :- |
| `403` with "Missing required OAuth2 scopes: ads.write" | The token is read-only | Follow "Switch to write access" on [page 04](04-connect-claude-code-and-desktop.md) |
| The same `403` after you changed the scopes and signed in again | You signed in from a session that was already open | Quit Claude Code, start a fresh session, then sign in again |
| `403` that does not mention a scope | The app is not enrolled for Ads API access | Recheck the Ads plan on [page 02](02-developer-console-app.md). X may also require its Ads API Access Form |
| `estimate_audience` fails on a read-only token | That tool needed the write scope in testing | Run it after you switch to write access, or skip it |

## Building the campaign

| Symptom | Likely cause | Fix |
| :- | :- | :- |
| No funding source can fund | No active card, or the card was declined | Add or fix the card in Ads Manager yourself |
| `create_ad_post` returns "may only be 280 characters long" | The server counts a link at its full length | Shorten the text or use a shorter link |
| The server rejects the automatic bid | The objective or placement does not allow it | Claude stops and proposes a fixed bid at or below your cap. Approve or change the draft |
| A build step fails halfway | An X-side validation error | Claude stops and shows the error. Fix the cause, then ask Claude to continue with the IDs it already created |

## Ad review

| Symptom | Likely cause | Fix |
| :- | :- | :- |
| The ad is rejected seconds after it is attached | The post has a hashtag. Press coverage says X has banned hashtags in ads since June 2025 | Use a post without a hashtag, or approve a promoted-only copy without it ([page 06](06-first-campaign-walkthrough.md)) |
| The ad is rejected and the API gives no reason | The API response has no reason field | Open the ad in Ads Manager, where X usually shows the policy reason |
| The campaign lists `ACCOUNT_UNDER_REVIEW` | X is reviewing a new ads account | Wait. In one case it took about two hours, and X sent an email |
| An ad stays `UNDER_REVIEW` for hours | X's review queue | Wait, and ask Claude to check later. You can launch the accepted ads alone |
| An ad you removed is still under review | Review did not finish while the ad was removed | Attach it again, which restarts review. On a running campaign this needs a spend card |
| The campaign looks fine but the ad is rejected | The campaign's status does not mention ad rejections | Ask Claude to read each ad's approval status directly |

The hashtag cause is likely and not confirmed, because X's API gave no reason for the rejection. X's [Quality Policy](https://business.x.com/en/help/ads-policies/ads-content-policies/quality-policy) covers hashtags, links and emoji in ad text, so read it before you write ad copy.

## After launch

| Symptom | Likely cause | Fix |
| :- | :- | :- |
| Status is "scheduled" | The start time has not arrived | Wait, or ask Claude to move the start time, which needs a new spend card |
| Stats are empty for hours | Stats lag, and a small budget delivers slowly | Check Ads Manager. Ask Claude again later |
| Stats are still empty at the end of the flight | The ad may not have won any auctions at this budget | It is not known whether X has a minimum effective budget. Try a larger cap if you choose to |
| A campaign changed state and Claude did not do it | Someone changed it in Ads Manager, or X did | Claude re-reads state before every launch and reports differences. Decide what to do with its report |

## Claude will not launch

This is usually the gate working as designed.

- Claude launches only on the exact reply `yes, launch`, typed after the newest spend card.
- A reply with a condition, such as a new budget, counts as a no. Claude shows a revised card.
- If your reply comes long after the card, Claude re-reads everything and shows a new card.
- A failed launch uses up your approval. Claude pauses everything and asks again.

## Still stuck

Open an issue on this repository. Leave out account IDs, campaign IDs, tokens and card details.
