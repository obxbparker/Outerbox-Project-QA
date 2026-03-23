#!/bin/bash
# install.sh — one-time global setup for the QA Team and Dev Assist Team
#
# Run this once after cloning, then re-run after every `git pull` to pick
# up updated agent definitions.
#
# Usage:
#   bash install.sh
#
# What it does:
#   Copies all command and agent files into ~/.claude/ so that /qa-audit
#   and /dev-assist are available as slash commands in every project.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo ""
echo "Installing QA Team and Dev Assist Team to $CLAUDE_DIR ..."
echo ""

# Create destination directories
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/qa-team/agents"
mkdir -p "$CLAUDE_DIR/qa-team/templates"
mkdir -p "$CLAUDE_DIR/dev-team/agents"
mkdir -p "$CLAUDE_DIR/dev-team/templates"

# Copy slash commands
cp "$SCRIPT_DIR/.claude/commands/qa-audit.md"   "$CLAUDE_DIR/commands/qa-audit.md"
cp "$SCRIPT_DIR/.claude/commands/qa-verify.md"  "$CLAUDE_DIR/commands/qa-verify.md"
cp "$SCRIPT_DIR/.claude/commands/dev-assist.md" "$CLAUDE_DIR/commands/dev-assist.md"

# Copy QA Team agent definitions and templates
cp "$SCRIPT_DIR/qa-team/agents/user-tester.md"               "$CLAUDE_DIR/qa-team/agents/"
cp "$SCRIPT_DIR/qa-team/agents/design-auditor.md"            "$CLAUDE_DIR/qa-team/agents/"
cp "$SCRIPT_DIR/qa-team/agents/ux-ui-auditor.md"             "$CLAUDE_DIR/qa-team/agents/"
cp "$SCRIPT_DIR/qa-team/agents/content-readiness-auditor.md" "$CLAUDE_DIR/qa-team/agents/"
cp "$SCRIPT_DIR/qa-team/agents/performance-auditor.md"       "$CLAUDE_DIR/qa-team/agents/"
cp "$SCRIPT_DIR/qa-team/agents/accessibility-auditor.md"     "$CLAUDE_DIR/qa-team/agents/"
cp "$SCRIPT_DIR/qa-team/templates/"*                         "$CLAUDE_DIR/qa-team/templates/"

# Copy Dev Assist Team agent definitions and templates
cp "$SCRIPT_DIR/dev-team/agents/code-reviewer.md"    "$CLAUDE_DIR/dev-team/agents/"
cp "$SCRIPT_DIR/dev-team/agents/code-implementer.md" "$CLAUDE_DIR/dev-team/agents/"
cp "$SCRIPT_DIR/dev-team/templates/"*                "$CLAUDE_DIR/dev-team/templates/"

echo "Installation complete."
echo ""
echo "  /qa-audit, /qa-verify, and /dev-assist are now available in every project."
echo "  Reports save to a reports/ folder inside whichever project you are working in."
echo ""
echo "Next steps:"
echo "  1. Restart the Claude Code extension in VSCode:"
echo "     macOS: Cmd+Shift+P → 'Restart Extension Host'"
echo "     Windows: Ctrl+Shift+P → 'Restart Extension Host'"
echo "  2. Open any project and type / in the Claude Code chat to verify the commands appear."
echo ""
echo "To update after a git pull:"
echo "  bash install.sh"
echo ""
