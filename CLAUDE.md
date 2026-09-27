# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal Linux dotfiles. Configuration is grouped by tool under top-level directories; an installer script symlinks (and in one case copies) the files into the appropriate locations under `$HOME`.

## Installing / applying changes

```sh
sh link_linux.sh
```

`link_linux.sh` sources `link_config.sh` (which sets `FROMDIR=$HOME/dotfiles` and `DISTDIR=$HOME`) and then runs `ln -fs` for every config file. There is no build, lint, or test command — this repo is config-only.

Because almost everything is installed via symlink, **editing a file in this repo immediately changes the live system** (next shell/editor invocation picks it up). Files that are copied rather than symlinked: `git/gitconfig` → `~/.gitconfig` (because `gitconfig` does not follow include semantics through symlinks reliably in some setups), `ai/apm/global/apm.yml` → `~/.apm/apm.yml`, `ai/claude/CLAUDE.md` → `~/.claude/CLAUDE.md`, and `ai/claude/settings.json` → `~/.claude/settings.json` (APM merges package hooks into it, which would otherwise write through the symlink into this repo); re-run `link_linux.sh` after editing them. Changes Claude Code makes to its own settings file are not written back here.

## Layout (where each tool's config lives)

- `shell/` — bash + zsh rc/profile files. `shell_common.sh` is sourced by both; aliases and shared logic go there. `shell_env_common.sh` is for env vars (locale, etc.).
- `vim/` — `vimrc` is used by both Vim and Neovim (linked to `~/.vimrc` and `~/.config/nvim/init.vim`). Plugin config lives in `vimrcs/plugins.lua` (Neovim only, gated on `$HOME/.vim_plug` existing); shared config lives in `vimrcs/common.vim`.
- `ai/` — AI tool configuration.
  - **Global AI context is managed by [APM](https://github.com/microsoft/apm)** and deployed to Claude Code, Codex and OpenCode. `ai/apm/global/apm.yml` is the user-scope manifest: `link_linux.sh` **copies** it to `~/.apm/apm.yml` (APM rejects a symlinked manifest) and runs `apm install -g && apm compile -g`. It declares:
    - `ai/apm/personal/` — the personal APM package. `.apm/instructions/personal.instructions.md` holds the personal global guidance (edit it for guidance that should apply to every project; do NOT duplicate its contents into this file). Personal skills / agents / commands / hooks go under `.apm/skills/`, `.apm/agents/`, `.apm/commands/`, `.apm/hooks/`.
    - Third-party packages (superpowers, `commit-commands`, `code-simplifier`) — installed via APM instead of Claude Code plugins, so they reach every target. Their Claude plugins are set to `false` in `ai/claude/settings.json` to avoid duplicates.
    - LSP servers (`dependencies.lsp`, Claude Code only) — replacing the `*-lsp` Claude plugins.
    - Company/team packages are added as further dependencies. The personal package is referenced remotely (`diginatu/dotfiles/ai/apm/personal#master`), so edits take effect only after pushing to `master` and re-running `apm install -g --update && apm compile -g`.
  - Claude Code gets the instructions via `~/.claude/rules/`; `ai/claude/CLAUDE.md` is a hand-authored placeholder copied to `~/.claude/CLAUDE.md` so that `apm compile -g` skips it instead of duplicating the rules. Codex / OpenCode get APM-generated `AGENTS.md`.
  - `ai/claude/settings.json` → `~/.claude/settings.json` (Claude Code permissions, plugins; copied, see above).
  - `ai/opencode/opencode.jsonc` → `~/.config/opencode/opencode.jsonc`.
- `cli/` — misc CLI tool configs: `aider.conf.yml`.
- `git/` — `gitconfig` (copied, not linked — see above) and `gitignore` (referenced via `core.excludesfile`).
- `terminal/` — `kitty/` and `wezterm/` configs, each linked into their respective `~/.config/` dirs.
- `etc/` — small, miscellaneous configs (`tmux.conf`, `qtvimrc`, `xbindkeysrc`).
- `docker/` — `config.json` is linked into both `~/.docker/` and `/root/.docker/` (the latter via `sudo` when not root). `base/Dockerfile` + `build.sh` build a personal dev base image (`diginatu/dev-base:latest`).
- `bin/` — small personal scripts; every file is symlinked into `~/bin/`. `bin/open` is additionally linked as `~/bin/xdg-open`.
- `nautilus-scripts/` — GNOME Files right-click scripts, linked into `~/.local/share/nautilus/scripts/`.
- `firefox/` — Firefox userContent + Vimium/Vimperator config (manual install; not handled by `link_linux.sh`).

## Conventions when editing

- **Adding a new config file:** put it in the appropriate tool directory and add the corresponding `ln -fs` line to `link_linux.sh`. The installer is idempotent (`ln -fs` overwrites).
- **Adding a shell alias / function:** put it in `shell/shell_common.sh` (sourced by both bash and zsh), not in `bashrc` or `zshrc` directly, unless it is genuinely shell-specific.
- **Vim config that should work in both Vim and Neovim:** put it in `vimrcs/common.vim`. Neovim-only plugin config goes in `vimrcs/plugins.lua`.
- **Personal scripts:** drop into `bin/` and add a symlink line if the bulk `ln -fs ${FROMDIR}/bin/*` glob does not already cover it (it does, for top-level files).

## Git workflow

Always commit and push directly to `master` — no feature branches, no PRs.

## Environment quirks to know

- `rm` is aliased to a "Do you mean tp?" message in `shell/shell_common.sh` (where `tp` = `gio trash`). To actually delete in a shell, use `\rm`. This only affects interactive shells — scripts and tool calls that invoke `rm` directly are unaffected.
- `vim` is aliased to `nvim` when nvim is installed; `EDITOR=nvim` follows.
- `gradle` is aliased to `./gradlew` (and `gr` to `gradle`), so a bare `gradle` in this user's shell will fail outside a Gradle project root.
