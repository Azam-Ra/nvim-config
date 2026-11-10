# Neovim config: setup notes

Setup that goes beyond cloning this repo to `~/.config/nvim`. Plugins are managed by
lazy.nvim, which bootstraps itself on first launch. Everything below is an external
dependency that lazy.nvim does not install.

## Requirements

- **Neovim >= 0.12** (developed on 0.12.6). The config uses `vim.lsp.enable()` and
  the `lsp/*.lua` config files, which need a recent version.
- **git**: lazy.nvim clones itself and all plugins with it.
- **A C compiler and `make`**: `telescope-fzf-native.nvim` is built with `make`, and
  nvim-treesitter compiles parsers.
- **`tree-sitter` CLI**: needed by the nvim-treesitter `main` branch to build
  parsers (`auto_install = true`, parsers listed in
  `lua/miller/plugins/treesitter.lua`).
- **ripgrep (`rg`)**: required by Telescope `live_grep`, which `<leader>fg` uses
  (via `telescope-live-grep-args.nvim`).
- **fd** (optional): `:checkhealth telescope` warns `fd: not found` without it.
  It is only used by `find_files` (`<leader>ff`), which falls back to a slower finder.

## Language servers

Servers are enabled in `lua/miller/lsp.lua`, with per-server config in `lsp/`. Nothing
installs them (no Mason), so each binary must be on `PATH`:

| Server | Binary | Install |
|---|---|---|
| C/C++ | `clangd` | via the `clang-tools` package or an LLVM install |
| Lua | `lua-language-server` | package manager, or the lua-language-server releases |
| Python | `pyright-langserver` | `npm i -g pyright` or `pip install pyright` |
| Bash | `bash-language-server` | `npm i -g bash-language-server` |

On NixOS, install them through `nixpkgs` (`clang-tools`, `lua-language-server`,
`pyright`, `bash-language-server`, `ripgrep`, `fd`, `tree-sitter`).

### clangd notes

- `lsp/clangd.lua` passes `--query-driver=/usr/**,/opt/**,/bin/**,/run/current-system/sw/bin/**`
  so clangd can find compilers in standard locations, including the NixOS system profile.
  Add your compiler's directory there if it lives elsewhere.
- clangd needs a `compile_commands.json` (or `compile_flags.txt`) in the project root.
  Generate it with CMake (`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`) or `bear -- make`.
- `--clang-tidy` and `--background-index` are on, so the first open of a large
  project is slow while it indexes.

## First launch

1. Start `nvim`. lazy.nvim bootstraps, then installs plugins pinned in `lazy-lock.json`.
2. Run `:checkhealth telescope lazy vim.lsp` and fix anything reported missing.
3. Open a file of each language to confirm the matching server attaches (`:checkhealth vim.lsp`).

## Using live grep (`<leader>fg`)

The prompt passes flags to ripgrep. Quote the search text first, otherwise the whole
prompt is treated as one literal pattern:

```
"require" -g *.lua
"require" -g **/lsp/**
"require" lsp
```

- `-g <glob>` filters files by path. `--iglob` is the case-insensitive version.
- A bare argument such as `lsp` is a literal directory path. Wildcards only work with `-g`.
- `<C-k>` quotes the prompt text, and `<C-i>` quotes it and appends ` --iglob `.

## Clipboard over SSH (`<leader>y`)

`<leader>y` yanks to the `+` register. Over SSH there is no local clipboard tool, so
`lua/miller/remap.lua` sets `vim.g.clipboard = "osc52"` when `SSH_TTY` is set. nvim then
copies by sending an OSC 52 escape sequence, and the terminal on your local machine
puts the text on its clipboard. This is copy only: paste locally with the terminal's
paste shortcut (Cmd+V on macOS), because `"+p` reads nvim's internal register.

For this to work, every layer between nvim and the local terminal must pass the sequence on.

1. **tmux on the remote host** (if you run nvim inside tmux). Add to `~/.tmux.conf`
   (here it is a symlink to `~/.config/tmux-config/tmux.conf`) and reload with
   `tmux source ~/.tmux.conf`:

   ```
   set -g set-clipboard on
   set -g allow-passthrough on
   ```

   The default `set-clipboard external` blocks applications inside tmux from setting
   the clipboard. If you also run tmux locally on the Mac, add the same two lines there.

2. **The local terminal must accept OSC 52.**
   - iTerm2: Preferences, Profiles, Terminal, enable "Applications in terminal may
     access clipboard".
   - Kitty, WezTerm, Alacritty and Ghostty: enabled by default.
   - Apple Terminal.app: not supported, use another terminal.

To test, restart nvim, select text, press `<leader>y`, and paste locally.

## Completion

`blink.cmp` provides automatic suggestions from LSP, paths, snippets, and buffer
words. Configuration lives in `lua/miller/plugins/completion.lua`; shared LSP
capabilities are set before servers start in `lua/miller/lsp.lua`.
The Lua fuzzy matcher avoids native binary dependencies on NixOS.

- `<C-n>` / `<C-p>` or arrow keys select suggestions; `<C-y>` accepts.
- `<C-space>` opens completion or toggles documentation; `<C-e>` dismisses it.
- `<Tab>` / `<S-Tab>` jump between snippet placeholders, otherwise retain normal behavior.
- Enter remains a newline. Nothing is preselected or inserted while browsing.
- Documentation appears automatically after selecting a suggestion.

Run `nvim --headless +qa` for a startup smoke test and `:checkhealth blink.cmp`
for completion diagnostics. Python requires Pyright; C/C++ requires clangd and
accurate compilation flags as described above.

## VS Code

When `vim.g.vscode` is set (vscode-neovim), only `lua/miller/vscode.lua` is loaded and
none of the plugins or LSP setup above applies.
