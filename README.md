# QA Agent Team

A reusable, AI-powered QA team for auditing web applications. Three specialist agents — a User Tester, Design Auditor, and UX/UI Auditor — are coordinated by a QA Manager to produce structured, prioritized audit reports.

The team uses Claude Code + the Playwright MCP to visually inspect and interact with the application being audited, not just read its source code.

---

## What the Team Does

| Agent | What They Look For |
|-------|-------------------|
| **User Tester** | Broken flows, form failures, edge cases, responsive issues, error handling — tests as a real user across all device sizes |
| **Design Auditor** | Pixel-perfect design adherence — spacing, typography, color, component consistency across all breakpoints |
| **UX/UI Auditor** | Interaction quality — sticky element bugs, missing feedback, inconsistent patterns, hover-only interactions, cognitive load |
| **QA Manager** | Coordinates all three, runs follow-up passes, synthesizes a prioritized report |

**This team evaluates only. It does not write code or implement fixes.** Output is a structured audit report with Critical, High, Normal, and Suggestion tiers that your development team can act on.

---

## Prerequisites

Before using this team, each developer machine needs:

| Requirement | Version | Purpose |
|-------------|---------|---------|
| **Claude Code** (VSCode extension) | Latest | The AI coding assistant that runs the agents |
| **Node.js** | 18 or higher | Required to run the Playwright MCP server |
| **Git** | Any recent version | For cloning and updating this repo |

---

## One-Time Machine Setup

This setup is done once per developer machine.

### Step 1: Install the Playwright MCP

The Playwright MCP gives Claude Code a real browser it can see, navigate, and interact with.

```bash
npm install -g @playwright/mcp
```

Then install the browsers Playwright needs:

```bash
npx playwright install chromium
```

> **Why chromium only?** Chromium covers the vast majority of audit needs. If you want cross-browser coverage, also run `npx playwright install firefox webkit`.

### Step 2: Configure Claude Code to Use Playwright

Claude Code needs to know about the Playwright MCP server. Add it to your user-level Claude configuration.

**Open (or create) `~/.claude.json`** and add the following. If the file already has content, merge the `mcpServers` key — don't replace the whole file.

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

> **Why user-level config?** The QA Agent Team spawns sub-agents using the Task tool. Those sub-agents inherit the Playwright MCP from the user-level config, giving each specialist agent their own browser access. The project-level `.mcp.json` in this repo covers the QA Manager — the user-level config covers the sub-agents.

### Step 3: Verify the Setup

Open the QA Team project in VSCode with Claude Code and ask: *"What Playwright browser tools do you have available?"* — Claude should list tools like `browser_navigate`, `browser_screenshot`, etc.

---

## Per-Project Setup (After Cloning)

### Step 1: Clone the Repository

```bash
git clone [your-repo-url] "QA Team"
cd "QA Team"
```

### Step 2: Open in VSCode

Open the `QA Team` folder as its own VSCode workspace:

```
File → Open Folder → select the QA Team folder
```

> **Important:** Open the `QA Team` folder directly, not as a subfolder inside a larger workspace. The `/qa-audit` command is a project-level command — it only appears when this specific project is active in Claude Code.

### Step 3: Verify the Command is Available

In the Claude Code chat panel, type `/` — you should see `qa-audit` appear in the command list. If it doesn't appear, make sure you have the `QA Team` folder open as the root workspace.

---

## Running an Audit

From the Claude Code chat panel with the QA Team project open:

### Audit a Live URL

```
/qa-audit https://yourapp.com
```

### Audit a Local Codebase

```
/qa-audit /Users/yourname/projects/my-app
```

### Audit with Design Specs (Figma + Live URL)

```
/qa-audit https://www.figma.com/file/xxxxx/Design https://yourapp.com
```

### Audit from Screenshots

```
/qa-audit /Users/yourname/Desktop/app-screenshots
```

### Mixed Inputs

You can combine multiple inputs — the QA Manager will classify each one:

```
/qa-audit https://yourapp.com /path/to/design-mockup.png
```

---

## What Happens During an Audit

1. **QA Manager classifies your input** — identifies URLs, local paths, design specs, and screenshots
2. **Initial visual capture** — If a live URL is provided, the QA Manager navigates to it and takes screenshots at 375px, 768px, 1280px, and 1440px viewports
3. **Three agents run in parallel** — User Tester, Design Auditor, and UX/UI Auditor each use Playwright to independently inspect the application
4. **QA Manager reviews results** — Deduplicates overlapping findings, identifies gaps
5. **Follow-up passes** — If any findings are vague or need more evidence, targeted follow-up investigations run
6. **Final report generated** — Saved to `reports/` in this repo and printed in full in the chat

---

## Understanding the Report

Reports are saved to the `reports/` folder with timestamped filenames:

```
reports/qa-report_2025-01-15_14-32-00_yourapp-com.md
```

### Severity Tiers

| Severity | Meaning | Action |
|----------|---------|--------|
| **Critical** | Broken flows, data loss risk, complete blockers | Fix before any release |
| **High** | Major UX failures, significant design deviations, accessibility violations | Fix as soon as possible |
| **Normal** | Minor inconsistencies, edge cases, suboptimal patterns | Fix in next sprint |
| **Suggestions** | Polish and enhancement opportunities | Add to backlog |

---

## Customizing the Agents

Each agent's behavior is defined in the `agents/` directory. Edit these files to tune what each agent looks for, how they prioritize, and what they report.

| File | Controls |
|------|---------|
| `agents/user-tester.md` | Personas, test coverage, severity definitions for functional testing |
| `agents/design-auditor.md` | Design evaluation criteria, what counts as a deviation |
| `agents/ux-ui-auditor.md` | Interaction patterns, red flags, UX severity definitions |

Changes take effect on the next `/qa-audit` run — no restart required.

The QA Manager orchestration logic lives in `.claude/commands/qa-audit.md`. Edit this to change how the team is coordinated, how many iteration passes it runs, or where reports are saved.

---

## Getting Updates

To pull the latest agent improvements:

```bash
git pull
```

No build step, no install. The agents are markdown files.

---

## Team Architecture

```
/qa-audit [target]
    │
    ▼
QA Manager (.claude/commands/qa-audit.md)
    │   Detects repo root, reads agent definitions,
    │   takes initial Playwright screenshots
    │
    ├──▶ User Tester (agents/user-tester.md)
    │       Uses Playwright to test as a real user
    │
    ├──▶ Design Auditor (agents/design-auditor.md)
    │       Uses Playwright to inspect visual fidelity
    │
    └──▶ UX/UI Auditor (agents/ux-ui-auditor.md)
            Uses Playwright to test interactions
    │
    ▼
QA Manager synthesizes, deduplicates, iterates
    │
    ▼
reports/qa-report_[timestamp]_[target].md
```

---

## Troubleshooting

### `/qa-audit` doesn't appear in the command list

Make sure you have the `QA Team` folder open as the **root** of your VSCode workspace — not as a subfolder inside a larger workspace. The command is project-scoped.

### Playwright browser tools aren't available

1. Verify the MCP config in `~/.claude.json` — check the JSON is valid (no trailing commas)
2. Verify the package is accessible: `npx @playwright/mcp@latest --version`
3. Restart the Claude Code extension: `Cmd+Shift+P` → "Restart Extension Host"

### The app requires authentication

Run the audit on publicly accessible pages first. For authenticated flows, pass credentials as a note:

```
/qa-audit https://yourapp.com --note "Login: admin@test.com / password123"
```

### Playwright can't reach a local dev server

Make sure your dev server is running before starting the audit. Use the full URL with port:

```
/qa-audit http://localhost:3000
```

### Reports directory is missing

```bash
mkdir -p reports && touch reports/.gitkeep
```

---

## Adding More Agents

To extend the team (e.g., add an Accessibility Specialist or Performance Auditor):

1. Create a new file in `agents/` following the same format as existing agents
2. Open `.claude/commands/qa-audit.md` and add the new agent to the "Spawn Audit Team" step
3. Update `templates/audit-report.md` to include a section for the new agent
4. Update this README

---

## File Structure

```
QA Team/
├── .claude/
│   └── commands/
│       └── qa-audit.md          ← The /qa-audit slash command (QA Manager)
├── agents/
│   ├── user-tester.md           ← User Tester role definition
│   ├── design-auditor.md        ← Design Auditor role definition
│   └── ux-ui-auditor.md         ← UX/UI Auditor role definition
├── templates/
│   └── audit-report.md          ← Report structure template
├── reports/                     ← Generated audit reports (gitignored)
│   └── .gitkeep
├── .mcp.json                    ← Project-level Playwright MCP config
├── CLAUDE.md                    ← Claude context for this project
├── .gitignore
└── README.md                    ← This file
```
