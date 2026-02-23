# Agent Teams

A reusable, AI-powered toolkit containing two agent teams designed to work together: a QA team that audits web applications, and a developer assist team that translates those findings into targeted code changes.

---

## Table of Contents

- [Quick Refresher](#quick-refresher)
- [Quick Start Guide](#quick-start-guide)
- [Global Installation](#global-installation)
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
- [Getting Updates](#getting-updates)
- [Team Architecture](#team-architecture)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)

---

## Quick Refresher

_Already set up? Here is everything you need._

Both commands are available in **every project** once you have run `install.sh`. You do not need to open this repository to use them.

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

Reports save automatically to a `reports/` folder inside whichever project you are working in.

### Updating Your Installation

After pulling new agent versions from Git:

```bash
cd /path/to/QA\ Team
git pull
bash install.sh
```

Then restart the Claude Code extension: `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows) → **Restart Extension Host**.

---

## Quick Start Guide

_New to this project? Follow these steps in order._

### Step 1 — Clone This Repository

```bash
git clone [your-repo-url] ~/Desktop/QA\ Team
```

You can clone it anywhere. The path above is a convention — pick whatever works for your machine.

### Step 2 — Install Node.js 18 or Higher

Required for the QA Team's Playwright browser. Download from [nodejs.org](https://nodejs.org).

> The Dev Assist Team does not require Node.

### Step 3 — Install the Playwright MCP

Run once per machine:

```bash
npm install -g @playwright/mcp
npx playwright install chromium
```

### Step 4 — Configure Claude Code to Use Playwright

Open or create `~/.claude.json`:

- macOS / Linux: `open -e ~/.claude.json`
- Windows: `notepad $env:USERPROFILE\.claude.json`

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

Save the file.

### Step 5 — Run the Install Script

```bash
bash ~/Desktop/QA\ Team/install.sh
```

This copies all agent files and slash commands into `~/.claude/`, making them available in every project.

### Step 6 — Restart the Claude Code Extension

- macOS: `Cmd+Shift+P` → **Restart Extension Host**
- Windows: `Ctrl+Shift+P` → **Restart Extension Host**

### Step 7 — Verify the Setup

Open any project in VSCode and type `/` in the Claude Code chat — both `/qa-audit` and `/dev-assist` should appear. Then ask: _"What Playwright browser tools do you have available?"_ — Claude should list tools like `browser_navigate`, `browser_screenshot`, etc.

### Step 8 — Run Your First Audit

Open a project, make sure its dev server is running, then:

```
/qa-audit http://localhost:3000
```

Then use the resulting report with the Dev Assist Team:

```
/dev-assist /path/to/your/app
```

The Dev Assist Team will find the most recent QA report in the project's `reports/` folder automatically.

---

## Global Installation

### How It Works

Claude Code looks for slash commands in two locations:

1. `.claude/commands/` inside the current project (project-scoped — only available in that project)
2. `~/.claude/commands/` in your home directory (**user-scoped — available in every project**)

Running `install.sh` copies the command files into `~/.claude/commands/` and copies all agent definition files into `~/.claude/qa-team/` and `~/.claude/dev-team/`. Once installed, both commands appear automatically in every project you open — no per-project setup required.

Reports are saved to a `reports/` folder inside whichever project you are working in at the time, not back into this repository.

### File Locations After Installation

```
~/.claude/                          ← your home directory, not this repo
├── commands/
│   ├── qa-audit.md                 ← /qa-audit available everywhere
│   └── dev-assist.md               ← /dev-assist available everywhere
├── qa-team/
│   ├── agents/
│   │   ├── user-tester.md
│   │   ├── design-auditor.md
│   │   ├── ux-ui-auditor.md
│   │   ├── content-readiness-auditor.md
│   │   ├── performance-auditor.md
│   │   └── accessibility-auditor.md
│   └── templates/
│       └── audit-report.md
└── dev-team/
    ├── agents/
    │   ├── code-reviewer.md
    │   └── code-implementer.md
    └── templates/
        └── review-report.md
```

### Onboarding a New Team Member

Every developer on your team follows the same four steps:

1. Clone this repository to their machine
2. Run `install.sh`
3. Confirm Playwright MCP is configured in `~/.claude.json` (Step 4 in Quick Start above)
4. Restart the Claude Code extension

That is it. The commands are now available in every project they open.

### Keeping Agent Definitions Up to Date

When agent definitions are updated in Git, team members update their installation by running two commands:

```bash
cd /path/to/QA\ Team
git pull && bash install.sh
```

The install script always overwrites `~/.claude/` with the latest versions. No manual file copying is needed.

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

From the Claude Code chat panel in any project:

#### Audit a Live URL

```
/qa-audit https://yourapp.com
```

#### Audit a Local Dev Server

```
/qa-audit http://localhost:3000
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
2. **Pre-audit questions** — QA Manager asks whether content is complete and what phone number should appear on the site
3. **Initial visual capture** — navigates to the URL and takes screenshots at 375px, 768px, 1280px, and 1440px viewports
4. **Six agents run in parallel** — User Tester, Design Auditor, UX/UI Auditor, Content Readiness Auditor, Performance Auditor, and Accessibility Auditor each independently inspect the application
5. **QA Manager reviews results** — deduplicates overlapping findings, identifies gaps
6. **Follow-up passes** — vague or unsubstantiated findings trigger targeted follow-up investigations
7. **Final report generated** — saved to `reports/` inside your project and printed in full in the chat

### Understanding the QA Report

Reports are saved with timestamped filenames inside your project:

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

Edit the agent definition files in this repository and re-run `install.sh` to push updates to all machines.

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

If only the codebase path is provided, the team looks for the most recent `qa-report_*.md` in the project's `reports/` folder:

```
/dev-assist /path/to/codebase
```

### What Happens During a Review

1. **Code Review Manager reads the QA report** — summarizes finding counts and severity breakdown
2. **Code Reviewer is spawned** — explores the codebase to locate the code behind each finding
3. **Review report is generated** — every finding mapped to an exact file and line, with current code quoted and a recommended change written
4. **Report is saved** to `reports/` inside your project and presented in full in the chat
5. **Developer is prompted** — choose to implement yourself, hand off to the Code Implementer, or specify which items to implement
6. **Code Implementer runs (if chosen)** — edits files one at a time, adds comments, stops at structural changes for explicit approval
7. **Implementation summary is presented** — what was done, what was skipped, any observations

### Understanding the Review Report

Reports are saved with timestamped filenames inside your project:

```
reports/dev-review_2025-01-15_14-32-00_my-app.md
```

Any change marked `[REQUIRES APPROVAL]` will cause the Code Implementer to stop and wait before proceeding. These represent structural modifications that the developer must explicitly authorize — this cannot be bypassed by Claude Code auto-approve settings.

### Customizing the Dev Assist Agents

Edit the agent definition files in this repository and re-run `install.sh` to push updates to all machines.

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

This setup is done once per developer machine. After completing it, both commands are permanently available in every project.

### Step 1: Clone the Repository

```bash
git clone [your-repo-url] ~/Desktop/QA\ Team
```

Clone it anywhere on your machine. The path above is just a convention.

### Step 2: Install the Playwright MCP

```bash
npm install -g @playwright/mcp
npx playwright install chromium
```

> **Why chromium only?** Chromium covers the vast majority of audit needs. For cross-browser coverage, also run `npx playwright install firefox webkit`.

### Step 3: Configure Claude Code to Use Playwright

Add the following to your user-level Claude configuration file. If the file already has content, merge the `mcpServers` key — do not replace the whole file.

**macOS / Linux** — the file is `~/.claude.json`. Open it with:

```bash
open -e ~/.claude.json
```

**Windows** — the file is at `C:\Users\YourName\.claude.json`. Open it with:

```powershell
notepad $env:USERPROFILE\.claude.json
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

> **Why user-level config?** Both commands spawn sub-agents via the Task tool. Sub-agents inherit the Playwright MCP from the user-level config, giving each specialist agent its own browser access.

### Step 4: Run the Install Script

```bash
bash ~/Desktop/QA\ Team/install.sh
```

This copies all agent definitions and command files into `~/.claude/`. You will see a confirmation message listing what was installed and where.

### Step 5: Restart the Claude Code Extension

- macOS: `Cmd+Shift+P` → **Restart Extension Host**
- Windows: `Ctrl+Shift+P` → **Restart Extension Host**

### Step 6: Verify the Setup

Open any project in VSCode with Claude Code and type `/` in the chat — both `/qa-audit` and `/dev-assist` should appear. Then ask: _"What Playwright browser tools do you have available?"_ — Claude should list tools like `browser_navigate`, `browser_screenshot`, etc.

---

## Getting Updates

When agent definitions or commands are updated in the repository:

```bash
cd ~/Desktop/QA\ Team
git pull
bash install.sh
```

Then restart the Claude Code extension to pick up the new versions.

No build step. No install of packages. The agents are markdown files — `git pull` and `bash install.sh` is all that is needed.

---

## Team Architecture

```
/qa-audit [target]                        /dev-assist [qa-report] [codebase]
    │                                             │
    ▼                                             ▼
QA Manager                               Code Review Manager
(~/.claude/commands/qa-audit.md)         (~/.claude/commands/dev-assist.md)
    │                                             │
    ├──▶ User Tester                              └──▶ Code Reviewer
    │    (~/.claude/qa-team/agents/)                   (~/.claude/dev-team/agents/)
    │                                             │
    ├──▶ Design Auditor                           ▼
    │                                       Developer prompted
    ├──▶ UX/UI Auditor                            │
    │                                             └──▶ Code Implementer (optional)
    ├──▶ Content Readiness Auditor
    │
    ├──▶ Performance Auditor
    │
    └──▶ Accessibility Auditor
    │
    ▼
{your-project}/reports/qa-report_[timestamp].md
                        dev-review_[timestamp].md
```

---

## Troubleshooting

### A command doesn't appear in the command list

1. Confirm you have run `install.sh` — check that `~/.claude/commands/qa-audit.md` exists
2. Restart the Claude Code extension: `Cmd+Shift+P` → **Restart Extension Host**

### Playwright browser tools aren't available

1. Verify the MCP config file — check the JSON is valid (no trailing commas)
   - macOS / Linux: `~/.claude.json`
   - Windows: `C:\Users\YourName\.claude.json`
2. Verify the package is accessible: `npx @playwright/mcp@latest --version`
3. Restart the Claude Code extension

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

The commands create `reports/` automatically. If you need to create it manually:

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
QA Team/                              ← This Git repository
├── install.sh                        ← Run this once per developer machine
├── .claude/
│   └── commands/
│       ├── qa-audit.md              ← The /qa-audit slash command (QA Manager)
│       └── dev-assist.md            ← The /dev-assist slash command (Code Review Manager)
├── qa-team/                         ← QA Team agent definitions
│   ├── agents/
│   │   ├── user-tester.md
│   │   ├── design-auditor.md
│   │   ├── ux-ui-auditor.md
│   │   ├── content-readiness-auditor.md
│   │   ├── performance-auditor.md
│   │   └── accessibility-auditor.md
│   └── templates/
│       └── audit-report.md
├── dev-team/                        ← Dev Assist Team agent definitions
│   ├── agents/
│   │   ├── code-reviewer.md
│   │   └── code-implementer.md
│   └── templates/
│       └── review-report.md
├── reports/                         ← Empty placeholder (actual reports save per-project)
│   └── .gitkeep
├── .mcp.json                        ← Playwright MCP config (used when running from this folder)
├── CLAUDE.md                        ← Claude context for this repository
├── .gitignore
└── README.md                        ← This file
```

After running `install.sh`, the commands and agent files are also present at:

```
~/.claude/                           ← Your home directory — globally available
├── commands/
│   ├── qa-audit.md
│   └── dev-assist.md
├── qa-team/agents/
├── qa-team/templates/
├── dev-team/agents/
└── dev-team/templates/
```
