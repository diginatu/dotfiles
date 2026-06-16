#!/bin/sh
# Claude Code status line — mirrors shell PROMPT style
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name')

# Shorten home directory to ~
home="$HOME"
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")

# Git branch (skip optional locks to avoid blocking)
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# Context remaining
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Build output
# Blue for directory, green for branch, dim for model
printf '\033[34m%s\033[0m' "$short_cwd"
if [ -n "$branch" ]; then
    printf ' \033[32m%s\033[0m' "$branch"
fi
printf ' \033[2m%s\033[0m' "$model"
if [ -n "$used_pct" ]; then
    printf ' \033[2mctx:%.0f%%\033[0m' "$used_pct"
fi
echo
