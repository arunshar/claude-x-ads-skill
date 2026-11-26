# claude-x-ads-skill

This repository holds a Claude Code skill and a step-by-step tutorial for running a small X Ads campaign from Claude through X's official Ads MCP server. The skill makes Claude stop and ask for your approval before anything spends money.

## Read this first

- **Unofficial:** This project is not affiliated with, endorsed by or supported by X Corp or Anthropic.
- **Real money:** The skill can create and launch real ads that charge your card. The software comes with no warranty, and the author is not liable for any spend. See [LICENSE](LICENSE).
- **The gate is instructions:** The skill tells Claude to stop and wait for your exact reply `yes, launch`. That is a rule the model follows. It is not a technical lock. Read [SECURITY.md](SECURITY.md) and add a backstop, such as a low-limit card.
- **Your responsibility:** You must follow the [X Ads Policies](https://business.x.com/en/help/ads-policies), the [Developer Agreement](https://docs.x.com/developer-terms/agreement), the [Automation Rules](https://help.x.com/en/rules-and-policies/x-automation) and your local advertising and tax law.
- **Read the skill:** Read [skills/x-ads-campaign/SKILL.md](skills/x-ads-campaign/SKILL.md) before you install it. It is short, and it is the whole product.

## Emergency stop

If an ad is running and you want it to stop now, do these in order. The details are in [docs/emergency-stop.md](docs/emergency-stop.md).

1. Open Ads Manager at ads.x.com and switch the campaign off.
2. In Claude, say "pause the campaign and the line item" and give their IDs or names. Pausing never needs approval.
3. To cut Claude off from your ads account, revoke the app's access in your X account settings and run `claude mcp remove x-ads`.

## What the skill does

You ask Claude to boost one of your X posts with a small budget. Claude then follows a fixed process:

1. It runs read-only checks on your ads account, card, existing campaigns and the post.
2. It shows you a draft plan and waits for your approval.
3. It builds the campaign, the ad group, the targeting and the ad, all **paused**, and reads each one back.
4. It shows a **spend card** filled from the values X returned.
5. It launches only when you reply exactly `yes, launch`.
6. It checks status on request, pauses on any problem, and wraps up at the end.

## How the safety model works

- X's server creates every campaign and ad group paused. Its two activate tools are the documented way to start spending. Changes made outside Claude, such as in Ads Manager, can also start it.
- The skill sorts every tool into a class. Reads are free, builds need an approved draft, and anything that can spend needs a fresh spend card.
- Only your exact `yes, launch`, typed after the newest card, counts as approval. "Approved" and "go ahead" do not.
- The skill sets both a total budget and an end time on the ad group, so spending has two limits on X's side.
- Claude never types passwords, card numbers or secrets, and never accepts terms or offers for you.

## What you need

- Claude Code 2.1.332 or later (the CLI, or the Code tab of the Claude desktop app)
- An X account, a developer app in the X Developer Console, and an X Ads account with a card
- About an hour for setup, plus X's review time for a new ads account

## Install

**As a plugin (Claude Code):**

```text
/plugin marketplace add arunshar/claude-x-ads-skill
```

```text
/plugin install x-ads-campaign@claude-x-ads-skill
```

**By manual copy:**

```bash
git clone https://github.com/arunshar/claude-x-ads-skill.git
```

```bash
mkdir -p ~/.claude/skills && cp -R claude-x-ads-skill/skills/x-ads-campaign ~/.claude/skills/
```

The skill does not connect the X Ads server for you. You add the server yourself with your own Client ID, as [docs/04](docs/04-connect-claude-code-and-desktop.md) explains.

## Tutorial

Follow the pages in order the first time.

| Page | What it covers |
| :- | :- |
| [01 Prerequisites](docs/01-prerequisites.md) | What you need, what it may cost, how long it takes |
| [02 Developer Console app](docs/02-developer-console-app.md) | Creating the app, the OAuth 2.0 settings, Ads API access |
| [03 Ads account and card](docs/03-ads-account-and-card.md) | The ads account, the payment method, offers, account review |
| [04 Connect Claude Code and the desktop app](docs/04-connect-claude-code-and-desktop.md) | `claude mcp add`, scopes, sign-in, the desktop app |
| [05 Install the skill](docs/05-install-the-skill.md) | Plugin install, manual copy, update, uninstall |
| [06 First campaign walkthrough](docs/06-first-campaign-walkthrough.md) | Example prompts and what Claude shows at each step |
| [07 Monitor, change, stop](docs/07-monitor-change-stop.md) | Status checks, adding an ad, pausing, wrap-up |
| [08 Troubleshooting](docs/08-troubleshooting.md) | Errors met in a real run and their fixes |
| [Emergency stop](docs/emergency-stop.md) | Three ways to stop spending |
| [Case study](docs/case-study.md) | A real first run: what went wrong and what it taught |

## Repository layout

```text
skills/x-ads-campaign/SKILL.md           the skill
skills/x-ads-campaign/references/        the setup reference the skill reads
docs/                                    the tutorial
.claude-plugin/                          plugin and marketplace manifests
scripts/check_repo.sh                    privacy and style checks for this repo
```

## Contributing

Open an issue or a pull request. Run `bash scripts/check_repo.sh` before you push. Do not include account IDs, campaign IDs, tokens or card details in issues, logs or screenshots.

## License

The project uses the MIT license. See [LICENSE](LICENSE).
