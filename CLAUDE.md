# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal Linux dotfiles. Configuration is grouped by tool under top-level directories; an installer script symlinks (and in one case copies) the files into the appropriate locations under `$HOME`.

## Installing / applying changes

```sh
sh link_linux.sh
```

`link_linux.sh` sources `link_config.sh` (which sets `FROMDIR=$HOME/dotfiles` and `DISTDIR=$HOME`) and then runs `ln -fs` for every config file. There is no build, lint, or test command — this repo is config-only.

Because almost everything is installed via symlink, **editing a file in this repo immediately changes the live system** (next shell/editor invocation picks it up). The only file that is copied rather than symlinked is `git/gitconfig` → `~/.gitconfig` (because `gitconfig` does not follow include semantics through symlinks reliably in some setups); re-run `link_linux.sh` after editing it.

## Layout (where each tool's config lives)

- `shell/` — bash + zsh rc/profile files. `shell_common.sh` is sourced by both; aliases and shared logic go there. `shell_env_common.sh` is for env vars (locale, etc.).
- `vim/` — `vimrc` is used by both Vim and Neovim (linked to `~/.vimrc` and `~/.config/nvim/init.vim`). Plugin config lives in `vimrcs/plugins.lua` (Neovim only, gated on `$HOME/.vim_plug` existing); shared config lives in `vimrcs/common.vim`.
- `ai/` — AI tool configuration.
  - `ai/AGENTS.md` is the **user-global** prompt; `link_linux.sh` symlinks it to `~/.claude/CLAUDE.md`. Edit it for guidance that should apply to every project, not just this one. Do NOT duplicate its contents into this file.
  - `ai/claude/settings.json` → `~/.claude/settings.json` (Claude Code permissions, hooks, plugins).
  - `ai/claude/agents/` → individual files symlinked into `~/.claude/agents/`.
  - `ai/opencode/opencode.jsonc` → `~/.config/opencode/opencode.jsonc`.
- `cli/` — misc CLI tool configs: `aider.conf.yml`, `gemini/settings.json`.
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
