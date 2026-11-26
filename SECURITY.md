# Security and safety

## What this skill can and cannot enforce

The skill is a set of instructions that Claude reads. It is not code that sits between Claude and X.

- **What it does:** It tells Claude to build everything paused, to show a spend card, and to launch only on your exact reply `yes, launch`.
- **What it cannot do:** It cannot technically block a tool call. A model can make mistakes, and text in a post or a tool result could try to mislead it. The skill tells Claude to treat such text as data, but that is also an instruction.
- **What X's server does:** It creates campaigns and ad groups paused. In the live tool schemas read in November 2026, its update tools could pause and could not activate. X's docs describe no confirmation step, spend cap or audit log on the server side.

## Backstops we recommend

Use at least one of these for any real spend.

- **A low-limit card:** Add a virtual or prepaid card with a small limit as the payment method in Ads Manager. This caps the loss outside Claude entirely.
- **Default permission mode:** Keep Claude Code's permission prompts on. Claude Code then asks you before each tool call, so you approve every write a second time.
- **Read-only scopes:** Keep the server's scopes at `ads.read offline.access` except while you build and run a campaign.
- **Budgets on X's side:** The skill always sets a total budget and an end time on the ad group. Check both on the spend card.
- **Ads Manager:** Confirm the final charge at ads.x.com. Stats in the API can lag.

## Secrets

- The OAuth 2.0 Client ID is public. Everything else is secret: access tokens, refresh tokens, client secrets, passwords, 2FA codes and card numbers.
- Never paste a secret into a chat, a file, an issue or a screenshot. If one is exposed, regenerate it in the X Developer Console.
- Claude Code stores the OAuth tokens for the server itself. This repository holds no credentials.

## Known limits

- It is not known whether X can bill slightly past a budget.
- Account state can change outside Claude, for example when you edit a campaign in Ads Manager. One run saw a paused campaign read as active again with no call from Claude. The skill re-reads state before each launch and after each pause.
- Claude acts only while a session is open and you ask it to check. It does not watch a campaign on its own.
- X keeps one live OAuth grant per app and user. A sign-in from a second client revokes the first client's tokens.

## Reporting a problem

If you find a way to make the skill launch or spend without the exact `yes, launch` reply, please report it through GitHub's private vulnerability reporting on this repository (Security tab, "Report a vulnerability"). For other problems, open an issue. Do not include account IDs, tokens or card details.
