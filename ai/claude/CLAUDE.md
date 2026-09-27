# Claude Code user memory

Global instructions are managed by APM (`~/dotfiles/ai/apm/`) and installed
into `~/.claude/rules/`. This hand-authored file exists so that
`apm compile -g` does not also write them here (which would duplicate them).
