#!/usr/bin/env bash
set -euo pipefail

# Workflow-DLC Installer
# 支持两种模式：link（默认，方便 git pull 更新）/ copy（兼容模式）

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_SRC="$SCRIPT_DIR/skills"
AGENTS_SRC="$SCRIPT_DIR/agents"
SKILLS_DST="$CLAUDE_DIR/skills"
AGENTS_DST="$CLAUDE_DIR/agents"

MODE="${1:-link}"
FORCE=false

usage() {
    cat <<EOF
Usage: ./install.sh [link|copy] [--force]

Modes:
  link   (default) 符号链接，git pull 后自动生效
  copy   复制文件，适合不保留仓库的场景

Options:
  --force  覆盖已存在的同名 skill/agent

Examples:
  ./install.sh          # 默认 link 模式
  ./install.sh copy     # 复制模式
  ./install.sh link --force  # 强制覆盖
EOF
    exit 0
}

# Parse args
for arg in "$@"; do
    case "$arg" in
        link|copy) MODE="$arg" ;;
        --force) FORCE=true ;;
        -h|--help) usage ;;
    esac
done

echo "🚀 Workflow-DLC Installer"
echo "   Mode: $MODE"
echo "   Source: $SCRIPT_DIR"
echo "   Target: $CLAUDE_DIR"
echo ""

# Ensure target dirs exist
mkdir -p "$SKILLS_DST"
mkdir -p "$AGENTS_DST"

installed_skills=0
installed_agents=0
skipped=0

install_item() {
    local src="$1"
    local dst="$2"
    local name="$(basename "$src")"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$FORCE" = true ]; then
            rm -rf "$dst"
        else
            echo "   ⏭️  Skip: $name (already exists, use --force to overwrite)"
            skipped=$((skipped + 1))
            return
        fi
    fi

    if [ "$MODE" = "link" ]; then
        ln -s "$src" "$dst"
    else
        cp -r "$src" "$dst"
    fi
}

# Install skills
echo "📦 Installing Skills..."
for skill_dir in "$SKILLS_SRC"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    install_item "$skill_dir" "$SKILLS_DST/$skill_name"
    installed_skills=$((installed_skills + 1))
done

# Install agents
echo "🤖 Installing Agents..."
for agent_file in "$AGENTS_SRC"/*.md; do
    [ -f "$agent_file" ] || continue
    agent_name="$(basename "$agent_file")"
    install_item "$agent_file" "$AGENTS_DST/$agent_name"
    installed_agents=$((installed_agents + 1))
done

echo ""
echo "✅ Done!"
echo "   Skills: $installed_skills installed"
echo "   Agents: $installed_agents installed"
[ "$skipped" -gt 0 ] && echo "   Skipped: $skipped (already existed)"
echo ""
echo "👉 Restart Claude Code to load new skills/agents."
echo "   Then type /workflow-start in any project to verify."
