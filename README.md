# Agent Teams

A reusable, AI-powered toolkit containing two agent teams designed to work together: a QA team that audits web applications, and a developer assist team that translates those findings into targeted code changes.

---

## Table of Contents

- [Quick Refresher](#quick-refresher)
- [Quick Start Guide](#quick-start-guide)
- [QA Team](#qa-team)
  - [What the QA Team Does](#what-the-qa-team-does)
  - [Running an Audit](#running-an-audit)
  - [What Happens During an Audit](#what-happens-during-an-audit)
  - [Understanding the QA Report](#understanding-the-qa-report)
  - [Customizing the QA Agents](#customizing-the-qa-agents)
- [Dev Assist Team](#dev-assist-team)
  - [What the Dev Assist Team Does](#what-the-dev-assist-team-does)
  - [Running a Review](#running-a-review)
  - [What Happens During a Review](#what-happens-during-a-review)
  - [Understanding the Review Report](#understanding-the-review-report)
  - [Customizing the Dev Assist Agents](#customizing-the-dev-assist-agents)
- [Prerequisites](#prerequisites)
- [One-Time Machine Setup](#one-time-machine-setup)
- [Per-Project Setup](#per-project-setup-after-cloning)
- [Getting Updates](#getting-updates)
- [Team Architecture](#team-architecture)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)

---

## Quick Refresher

_Already completed setup? Here is everything you need._

Open this project folder in VSCode, then type in the Claude Code chat:

### QA Team Commands

| Goal | Command |
|------|---------|
| Audit a live site | `/qa-audit https://yourapp.com` |
| Audit a local dev server | `/qa-audit http://localhost:3000` |
| Audit a local codebase | `/qa-audit /Users/yourname/projects/my-app` |
| Audit with Figma design specs | `/qa-audit https://figma.com/file/xxx https://yourapp.com` |
| Audit with an auth note | `/qa-audit https://yourapp.com --note "Login: user@test.com / pass123"` |

### Dev Assist Team Commands

| Goal | Command |
|------|---------|
| Review a QA report against a codebase | `/dev-assist /path/to/qa-report.md /path/to/codebase` |
| Review using the most recent QA report | `/dev-assist /path/to/codebase` |

Reports from both teams save automatically to the `reports/` folder.

---

## Quick Start Guide

_New to this project? Follow these steps._

**Step 1 — Install Node.js 18 or higher** if you have not already: [nodejs.org](https://nodejs.org)

> The Dev Assist Team does not require Node. This is only needed for the QA Team's Playwright browser.

**Step 2 — Install the Playwright MCP** (one-time, per machine, QA Team only):

```bash
npm install -g @playwright/mcp
npx playwright install chromium
```

**Step 3 — Configure Claude Code** to use Playwright. Open or create `~/.claude.json`:

- macOS: run `open -e ~/.claude.json` in Terminal
- Windows: run `notepad $env:USERPROFILE\.claude.json` in PowerShell

Add this content (merge if the file already has content — do not replace the whole file):

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

**Step 4 — Clone this repository** and open the folder in VSCode as its own workspace:

```
File → Open Folder → select this project folder
```

**Step 5 — Verify the setup.** Type `/` in the Claude Code chat — both `qa-audit` and `dev-assist` should appear. Then ask: _"What Playwright browser tools do you have available?"_ — Claude should list tools like `browser_navigate`, `browser_screenshot`, etc.

**Step 6 — Run your first audit:**

```
/qa-audit https://yourapp.com
```

Then use the resulting report with the Dev Assist Team:

```
/dev-assist /path/to/reports/qa-report_[timestamp].md /path/to/your/app
```

For detailed setup instructions, see [One-Time Machine Setup](#one-time-machine-setup) below.

---

## QA Team

### What the QA Team Does

| Agent | What They Look For |
|-------|-------------------|
| **User Tester** | Broken flows, form failures, edge cases, responsive issues, error handling — tests as a real user across all device sizes |
| **Design Auditor** | Pixel-perfect design adherence — spacing, typography, color, component consistency across all breakpoints |
| **UX/UI Auditor** | Interaction quality — sticky element bugs, missing feedback, inconsistent patterns, hover-only interactions, cognitive load |
| **Content Readiness Auditor** | Placeholder text, missing/wrong contact info, phone number verification, broken images, page titles, meta tags, legal pages — adapts to scaffold vs. content-complete mode |
| **Performance Auditor** | Console errors, page load times, unoptimized images, missing lazy loading, layout shift, failed network requests |
| **Accessibility Auditor** | WCAG 2.1 AA — semantic structure, heading hierarchy, keyboard operability, focus visibility, ARIA, form labels, landmark regions, skip navigation, image alt text, link purpose |
| **QA Manager** | Coordinates all six, asks pre-audit questions, runs follow-up passes, synthesizes a prioritized report |

**This team evaluates only. It does not write code or implement fixes.** Output is a structured audit report with Critical, High, Normal, and Suggestion tiers.

> **Note on accessibility scope:** The UX/UI Auditor covers keyboard operability and focus visibility from an interaction quality perspective. The Accessibility Auditor covers the same areas from a WCAG conformance perspective, plus semantic structure, ARIA, and programmatic relationships that assistive technologies depend on. The QA Manager deduplicates overlapping findings in the final report.

### Running an Audit

From the Claude Code chat panel:

#### Audit a Live URL

```
/qa-audit https://yourapp.com
```

#### Audit a Local Codebase

**macOS / Linux:**
```
/qa-audit /Users/yourname/projects/my-app
```

**Windows:**
```
/qa-audit C:\Users\yourname\projects\my-app
```

#### Audit with Design Specs (Figma + Live URL)

```
/qa-audit https://www.figma.com/file/xxxxx/Design https://yourapp.com
```

#### Audit from Screenshots

```
/qa-audit /Users/yourname/Desktop/app-screenshots
```

#### Mixed Inputs

```
/qa-audit https://yourapp.com /path/to/design-mockup.png
```

### What Happens During an Audit

1. **QA Manager classifies your input** — identifies URLs, local paths, design specs, and screenshots
2. **Initial visual capture** — navigates to the URL and takes screenshots at 375px, 768px, 1280px, and 1440px viewports
3. **Three agents run in parallel** — User Tester, Design Auditor, and UX/UI Auditor each independently inspect the application
4. **QA Manager reviews results** — deduplicates overlapping findings, identifies gaps
5. **Follow-up passes** — vague or unsubstantiated findings trigger targeted follow-up investigations
6. **Final report generated** — saved to `reports/` and printed in full in the chat

### Understanding the QA Report

Reports are saved with timestamped filenames:

```
reports/qa-report_2025-01-15_14-32-00_yourapp-com.md
```

| Severity | Meaning | Action |
|----------|---------|--------|
| **Critical** | Broken flows, data loss risk, complete blockers | Fix before any release |
| **High** | Major UX failures, significant design deviations, accessibility violations | Fix as soon as possible |
| **Normal** | Minor inconsistencies, edge cases, suboptimal patterns | Fix in next sprint |
| **Suggestions** | Polish and enhancement opportunities | Add to backlog |

### Customizing the QA Agents

| File | Controls |
|------|---------|
| `qa-team/agents/user-tester.md` | Personas, test coverage, severity definitions for functional testing |
| `qa-team/agents/design-auditor.md` | Design evaluation criteria, what counts as a deviation |
| `qa-team/agents/ux-ui-auditor.md` | Interaction patterns, red flags, UX severity definitions |
| `qa-team/agents/content-readiness-auditor.md` | Scaffold vs. content-complete mode behavior, what counts as placeholder content, phone number verification |
| `qa-team/agents/performance-auditor.md` | Performance thresholds, image size limits, console error handling, CLS scoring |
| `qa-team/agents/accessibility-auditor.md` | WCAG criteria scope, severity thresholds, what counts as a violation vs. enhancement |

The QA Manager orchestration logic lives in `.claude/commands/qa-audit.md`.

---

## Dev Assist Team

### What the Dev Assist Team Does

| Agent | What They Do |
|-------|-------------|
| **Code Reviewer** | Reads the QA report and the actual codebase. Maps each finding to an exact file and line range. Writes targeted change recommendations. Flags structural changes for approval. |
| **Code Implementer** | Implements the Code Reviewer's recommendations one at a time. Re-reads each file before editing. Adds comments. Stops for developer approval on structural changes. |
| **Code Review Manager** | Coordinates both agents, manages the developer handoff prompt, saves reports, relays approval requests. Never modifies code directly. |

**This team modifies code with precision. It does not rewrite, refactor, or expand scope beyond what the QA report describes.**

### Running a Review

#### Review a QA Report Against a Codebase

```
/dev-assist /path/to/qa-report.md /path/to/codebase
```

#### Review Using the Most Recent QA Report

If only the codebase path is provided, the team looks for the most recent `qa-report_*.md` in the `reports/` folder:

```
/dev-assist /path/to/codebase
```

### What Happens During a Review

1. **Code Review Manager reads the QA report** — summarizes finding counts and severity breakdown
2. **Code Reviewer is spawned** — explores the codebase to locate the code behind each finding
3. **Review report is generated** — every finding mapped to an exact file and line, with current code quoted and a recommended change written
4. **Report is saved** to `reports/` and presented in full in the chat
5. **Developer is prompted** — choose to implement yourself, hand off to the Code Implementer, or specify which items to implement
6. **Code Implementer runs (if chosen)** — edits files one at a time, adds comments, stops at structural changes for explicit approval
7. **Implementation summary is presented** — what was done, what was skipped, any observations

### Understanding the Review Report

Reports are saved with timestamped filenames:

```
reports/dev-review_2025-01-15_14-32-00_my-app.md
```

Any change marked `[REQUIRES APPROVAL]` will cause the Code Implementer to stop and wait before proceeding. These represent structural modifications that the developer must explicitly authorize — this cannot be bypassed by Claude Code auto-approve settings.

### Customizing the Dev Assist Agents

| File | Controls |
|------|---------|
| `dev-team/agents/code-reviewer.md` | How findings are mapped to code, what gets flagged for approval, reporting format |
| `dev-team/agents/code-implementer.md` | How changes are applied, comment style, approval gate behavior |

The orchestration logic lives in `.claude/commands/dev-assist.md`.

---

## Prerequisites

| Requirement | Version | Needed For |
|-------------|---------|-----------|
| **Claude Code** (VSCode extension) | Latest | Both teams |
| **Node.js** | 18 or higher | QA Team (Playwright MCP) |
| **Git** | Any recent version | Both teams |

The Dev Assist Team uses only Claude Code's built-in file tools — no additional packages or configuration required beyond what the QA Team already sets up.

---

## One-Time Machine Setup

This setup is done once per developer machine.

### Step 1: Install the Playwright MCP

```bash
npm install -g @playwright/mcp
npx playwright install chromium
```

> **Why chromium only?** Chromium covers the vast majority of audit needs. For cross-browser coverage, also run `npx playwright install firefox webkit`.

### Step 2: Configure Claude Code to Use Playwright

Add the following to your user-level Claude configuration file. If the file already has content, merge the `mcpServers` key — do not replace the whole file.

**macOS / Linux** — the file is `~/.claude.json`, where `~` is your home folder (e.g. `/Users/bradleyparker/.claude.json`).

This file is hidden by default because it starts with a `.` — Finder will not show it. Open or create it with Terminal:

```bash
open -e ~/.claude.json
```

This opens it in TextEdit (creating the file if it does not exist). If you prefer VS Code:

```bash
code ~/.claude.json
```

Add this content:

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

**Windows** — the file is at `C:\Users\YourName\.claude.json`. Open or create it with PowerShell:

```powershell
notepad $env:USERPROFILE\.claude.json
```

Notepad will prompt you to create the file if it does not exist. Add the same content.

> **Why user-level config?** Both commands spawn sub-agents via the Task tool. Sub-agents inherit the Playwright MCP from the user-level config, giving each specialist agent its own browser access. The project-level `.mcp.json` covers the QA Manager — the user-level config covers the sub-agents.

### Step 3: Verify the Setup

Open this project in VSCode with Claude Code and ask: _"What Playwright browser tools do you have available?"_ — Claude should list tools like `browser_navigate`, `browser_screenshot`, etc.

---

## Per-Project Setup (After Cloning)

### Step 1: Clone the Repository

```bash
git clone [your-repo-url] "Agent Teams"
cd "Agent Teams"
```

### Step 2: Open in VSCode

Open the project folder as its own VSCode workspace:

```
File → Open Folder → select this project folder
```

> **Important:** Open this folder directly, not as a subfolder inside a larger workspace. Both `/qa-audit` and `/dev-assist` are project-scoped commands — they only appear when this project is the active root workspace.

### Step 3: Verify the Commands are Available

In the Claude Code chat panel, type `/` — both `qa-audit` and `dev-assist` should appear in the command list.

---

## Getting Updates

```bash
git pull
```

No build step, no install. The agents are markdown files.

---

## Team Architecture

```
/qa-audit [target]                        /dev-assist [qa-report] [codebase]
    │                                             │
    ▼                                             ▼
QA Manager                               Code Review Manager
(.claude/commands/qa-audit.md)           (.claude/commands/dev-assist.md)
    │                                             │
    ├──▶ User Tester                              └──▶ Code Reviewer
    │    (agents/user-tester.md)                       (dev-team/agents/code-reviewer.md)
    │                                             │
    ├──▶ Design Auditor                           ▼
    │    (agents/design-auditor.md)          Developer prompted
    │                                             │
    ├──▶ UX/UI Auditor                            └──▶ Code Implementer (optional)
    │    (agents/ux-ui-auditor.md)                     (dev-team/agents/code-implementer.md)
    │
    ├──▶ Content Readiness Auditor
    │    (agents/content-readiness-auditor.md)
    │
    ├──▶ Performance Auditor
    │    (agents/performance-auditor.md)
    │
    └──▶ Accessibility Auditor
         (agents/accessibility-auditor.md)
    │
    ▼
reports/qa-report_[timestamp]_[target].md    reports/dev-review_[timestamp]_[codebase].md
```

---

## Troubleshooting

### A command doesn't appear in the command list

Make sure this folder is open as the **root** of your VSCode workspace — not as a subfolder inside a larger workspace. Both commands are project-scoped.

### Playwright browser tools aren't available

1. Verify the MCP config file — check the JSON is valid (no trailing commas)
   - macOS / Linux: `~/.claude.json`
   - Windows: `C:\Users\YourName\.claude.json`
2. Verify the package is accessible: `npx @playwright/mcp@latest --version`
3. Restart the Claude Code extension:
   - macOS: `Cmd+Shift+P` → "Restart Extension Host"
   - Windows: `Ctrl+Shift+P` → "Restart Extension Host"

### The app requires authentication

```
/qa-audit https://yourapp.com --note "Login: admin@test.com / password123"
```

### Playwright can't reach a local dev server

Make sure your dev server is running before starting the audit:

```
/qa-audit http://localhost:3000
```

### Reports directory is missing

**macOS / Linux:**
```bash
mkdir -p reports && touch reports/.gitkeep
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force reports; New-Item reports\.gitkeep
```

---

## File Structure

```
Agent Teams/
├── .claude/
│   └── commands/
│       ├── qa-audit.md              ← The /qa-audit slash command (QA Manager)
│       └── dev-assist.md            ← The /dev-assist slash command (Code Review Manager)
├── qa-team/                         ← QA Team files
│   ├── agents/
│   │   ├── user-tester.md
│   │   ├── design-auditor.md
│   │   ├── ux-ui-auditor.md
│   │   ├── content-readiness-auditor.md
│   │   ├── performance-auditor.md
│   │   └── accessibility-auditor.md
│   └── templates/
│       └── audit-report.md
├── dev-team/                        ← Dev Assist Team files
│   ├── agents/
│   │   ├── code-reviewer.md
│   │   └── code-implementer.md
│   └── templates/
│       └── review-report.md
├── reports/                         ← All generated reports (gitignored)
│   └── .gitkeep
├── .mcp.json                        ← Project-level Playwright MCP config
├── CLAUDE.md                        ← Claude context for this project
├── .gitignore
└── README.md                        ← This file
```
