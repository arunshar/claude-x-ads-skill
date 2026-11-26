#!/usr/bin/env bash
# Privacy, style and structure checks for this repository.
# The script holds generic patterns only. It never lists a real identifier.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'PY'
import json
import os
import re
import subprocess
import sys

problems = []


def report(path, line_no, reason, text=""):
    problems.append(f"{path}:{line_no}: {reason}: {text.strip()[:100]}")


tracked = subprocess.run(
    ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
    capture_output=True, text=True, check=True,
).stdout.split("\0")
files = [f for f in tracked if f and os.path.isfile(f)]

# Privacy and secret patterns, applied to every file.
HOME_PATH = "/" + "Users/"
LINUX_HOME = "/" + "home/"
WIN_HOME = "\\" + "Users" + "\\"
privacy = [
    (re.compile(r"(?<!\d)\d{15,20}(?!\d)"), "long numeric ID"),
    (re.compile(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+\.[A-Za-z]{2,}"), "email address"),
    (re.compile(re.escape(HOME_PATH)), "home directory path"),
    (re.compile(re.escape(LINUX_HOME) + r"[a-z]"), "home directory path"),
    (re.compile(re.escape(WIN_HOME)), "home directory path"),
    (re.compile(r"x\.com/(?!yourhandle/)\w{1,15}/status/"), "link to a real post"),
    (re.compile(r"(?i)bearer\s+[A-Za-z0-9._-]{20,}"), "bearer token"),
    (re.compile(r"(?i)(client_secret|access_token|refresh_token)[\"']?\s*[=:]\s*[\"']?[A-Za-z0-9._-]{12,}"), "secret value"),
    (re.compile(r"(?i)ending in \d{4}"), "card detail"),
    (re.compile(r"(?i)\b(visa|mastercard|amex|american express|discover)\b.{0,20}\d{4}"), "card detail"),
]
EM_DASH = "\u2014"

for path in files:
    try:
        lines = open(path, encoding="utf-8").read().split("\n")
    except UnicodeDecodeError:
        continue
    for n, line in enumerate(lines, 1):
        for pattern, reason in privacy:
            if pattern.search(line):
                report(path, n, reason, line)
        if EM_DASH in line:
            report(path, n, "em dash", line)

# Prose rules, applied to Markdown outside code fences and inline code.
label_outside = re.compile(r"\*\*[^*\n]+\*\*\s*:")
label_spaced = re.compile(r"\*\*[^*\n]*\s:\*\*")
label_period = re.compile(r"^\s*(?:[-*]|\d+\.)?\s*\*\*[^*\n]+\.\*\*\s+\S")
label_bare = re.compile(r"^\s*(?:[-*]|\d+\.)?\s*\*\*[^*\n]*[^:*.\n]\*\*\s+\S")
link = re.compile(r"\[[^\]]+\]\(([^)\s]+)\)")

for path in [f for f in files if f.endswith(".md")]:
    in_fence = False
    for n, line in enumerate(open(path, encoding="utf-8").read().split("\n"), 1):
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        prose = re.sub(r"`[^`]*`", "", line)
        if ";" in prose:
            report(path, n, "semicolon in prose", line)
        if label_outside.search(prose) or label_spaced.search(prose):
            report(path, n, "bold label must end with a colon inside the bold", line)
        if label_period.search(prose):
            report(path, n, "bold lead-in label ends with a full stop", line)
        if label_bare.search(prose):
            report(path, n, "bold lead-in label has no colon", line)
        for target in link.findall(prose):
            if target.startswith(("http://", "https://", "#", "mailto:")):
                continue
            local = os.path.normpath(os.path.join(os.path.dirname(path), target.split("#")[0]))
            if not os.path.exists(local):
                report(path, n, "broken relative link", target)

# Optional local denylist. The file is ignored by git and never committed.
if os.path.isfile(".denylist.local"):
    terms = [t.strip() for t in open(".denylist.local", encoding="utf-8") if t.strip()]
    for path in files:
        try:
            body = open(path, encoding="utf-8").read()
        except UnicodeDecodeError:
            continue
        for n, line in enumerate(body.split("\n"), 1):
            for term in terms:
                if term in line:
                    report(path, n, "local denylist term", "(term hidden)")

# Structure.
for manifest in (".claude-plugin/plugin.json", ".claude-plugin/marketplace.json"):
    try:
        data = json.load(open(manifest, encoding="utf-8"))
        if not data.get("name"):
            report(manifest, 1, "manifest has no name")
    except (OSError, ValueError) as exc:
        report(manifest, 1, "invalid or missing JSON", str(exc))

for required in ("LICENSE", "README.md", "SECURITY.md", "skills/x-ads-campaign/SKILL.md"):
    if not os.path.isfile(required):
        report(required, 1, "required file is missing")

skill = "skills/x-ads-campaign/SKILL.md"
if os.path.isfile(skill):
    text = open(skill, encoding="utf-8").read()
    front = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not front or "name:" not in front.group(1) or "description:" not in front.group(1):
        report(skill, 1, "front matter needs name and description")
    for phrase in ("yes, launch", "PAUSED", "Spend card required"):
        if phrase not in text:
            report(skill, 1, "skill lost a required safety phrase", phrase)

if problems:
    print("\n".join(problems))
    print(f"\ncheck_repo: {len(problems)} problem(s)")
    sys.exit(1)
print(f"check_repo: OK ({len(files)} files)")
PY
