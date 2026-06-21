# ctxstat

Real-time context health for Claude Code. Know when you're in the smart zone — before you hit the dumb zone.

![bash](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnubash&logoColor=white)
![Claude Code](https://img.shields.io/badge/Claude%20Code-statusLine-orange)
![license](https://img.shields.io/badge/license-MIT-blue)

## What it shows

```
Claude Sonnet 4.6 │ ✍️  66k 33% (Smart) │ myproject (main) │ ⏱ 12m │ ◑ default

current ●●●○○○○○○○  28% ⟳ 3:45pm
weekly  ●●○○○○○○○○  18% ⟳ jun 27, 9:00am
```

- **Model** — display name from Claude Code
- **Tokens + %** — current context usage, color-coded by zone
- **Zone label** — Smart / Watch / Caution / Dumb
- **Git branch** — with dirty indicator `*`
- **Session duration** — time since session start
- **Effort level** — from `~/.claude/settings.json`
- **Rate limits** — 5-hour and 7-day utilization bars (requires Claude.ai OAuth)

## Zones

| Zone    | Range  | Color  |
|---------|--------|--------|
| Smart   | 0–39%  | Green  |
| Watch   | 40–59% | Orange |
| Caution | 60–79% | Yellow |
| Dumb    | 80–100%| Red    |

## Install

**1. Copy the script:**

```sh
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

**2. Add to `~/.claude/settings.json`:**

```json
{
  "statusLine": "bash \"$HOME/.claude/statusline.sh\""
}
```

**3. Start a Claude Code session** — the statusline appears automatically.

## Requirements

- `bash` (macOS or Linux)
- `jq` — JSON parsing (`brew install jq` / `apt install jq`)
- `curl` — for rate limit data (optional)
- Claude Code CLI

## Rate limits

Rate limit bars (current / weekly) fetch from the Anthropic OAuth usage API. They appear automatically if you're logged in via Claude.ai OAuth. No API key needed.

Data is cached for 60 seconds in `/tmp/claude/statusline-usage-cache.json`.

## Model compatibility

Works with any Claude Code session. Context window size comes directly from Claude Code's reported value — accurate across Sonnet, Opus, Haiku, Fable, and future models.

## Customization

Colors, thresholds, and zone names are defined at the top of `statusline.sh`:

- `color_for_pct()` — returns ANSI color by zone
- `zone_label()` — returns Smart / Watch / Caution / Dumb
- Bar width: `bar_width=10` in the rate limits section

## License

MIT
