# nvim-config

A small Neovim configuration for Windows and macOS.

## Features

- Fuzzy finding with MiniPick
- Treesitter highlighting and indentation
- Native LSP completion, diagnostics, references, and format-on-save
- Automatic language-server installation with Mason
- Git hunk signs and actions
- Indentation detection
- Automatic pairs
- Floating terminal

## Requirements

- Neovim 0.11.3 or newer
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep) for live text search
- A C compiler for Treesitter parsers

Language servers may also require their language runtime or toolchain. Check
`:Mason` if a server does not install.

## Install

Back up any existing Neovim configuration first.

### Windows

```powershell
git clone https://github.com/nehpe/nvim-config.git "$env:LOCALAPPDATA\nvim"
nvim
```

### macOS

```sh
git clone https://github.com/nehpe/nvim-config.git ~/.config/nvim
nvim
```

Lazy.nvim installs plugins on first launch. Mason then installs the configured
language servers.

## Language servers

The config enables:

- Bash
- C and C++
- C#
- Go
- JSON
- Lua
- Python
- Rust
- TypeScript and JavaScript
- YAML
- Zig

## Keymaps

The leader key is `Space`.

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Search text |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Search help |
| `<leader>fk` | Search keymaps |
| `<leader>f.` | Resume the last picker |
| `<leader>cd` | Buffer diagnostics |
| `<leader>cs` | Document symbols |
| `<leader>cS` | Workspace symbols |
| `<leader>cf` | Format the current buffer |
| `]h` / `[h` | Next / previous Git hunk |
| `<leader>gp` | Preview Git hunk |
| `<leader>gs` | Stage Git hunk |
| `<leader>gr` | Reset Git hunk |
| `<leader>gb` | Blame current line |
| `<leader>ts` | Toggle spell checking |
| `<C-\>` | Toggle floating terminal |

Neovim's native LSP mappings remain available, including `grn`, `gra`, `grr`,
`gri`, `gO`, and `K`. Native `gc` and `gcc` handle comments.

## Update

Open `:Lazy` to update plugins and `:Mason` to inspect language servers.
