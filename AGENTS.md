# Repository Guidelines

## Project Structure & Module Organization
- `init.lua` bootstraps Neovim and loads `lua/config/*` and `lua/plugins/*`.
- `lua/config/` holds core settings and keymaps (`options.lua`, `keymaps.lua`, `lazy.lua`).
- `lua/plugins/` contains Lazy.nvim plugin specs (one plugin per file).
- `lua/lsp/` and `after/lsp/` provide LSP-specific configuration and overrides.
- `lazy-lock.json` pins plugin versions; update intentionally.
- `stylua.toml` defines Lua formatting rules.

## Build, Test, and Development Commands
- `nvim` starts the config locally.
- `:Lazy` opens the plugin manager UI.
- `:Lazy sync` installs/updates plugins to match `lazy-lock.json`.
- `:Mason` manages external LSP/formatting tools.
- `:ConformInfo` shows active formatters for the current buffer.

## Coding Style & Naming Conventions
- Lua uses 2-space indentation and 120-column width (`stylua.toml`).
- Formatting is automated via `conform.nvim` on save; Lua uses `stylua`, JS/TS/JSON/YAML/Markdown use `prettier`.
- Keep plugin specs in `lua/plugins/<name>.lua` and follow the existing module naming pattern.

## Testing Guidelines
- This repository does not include automated tests. Validate changes by launching Neovim and exercising the affected features or keymaps.

## Commit & Pull Request Guidelines
- Git history uses short, descriptive summaries (often in Japanese). There is no enforced commit format; keep messages concise and focused.
- PRs should explain the intent, list user-visible behavior changes, and include screenshots or GIFs for UI changes (e.g., status line, tree, theme).
- If a change affects plugin versions or tooling, mention any required local steps (e.g., `:Lazy sync`, `:Mason`).

## Configuration Tips
- Prefer editing settings under `lua/config/` and plugin behavior under `lua/plugins/` to keep concerns separated.
- If a change is filetype-specific, place it under `after/` or `lua/lsp/` to minimize global impact.
