# Neovim Config

Personal Neovim configuration built on [NvChad v2.5](https://github.com/NvChad/NvChad).

## Stack

- **Plugin manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP:** basedpyright, ruff, lua_ls, html, cssls, bashls, jsonls (via Mason)
- **Formatting:** conform.nvim + none-ls (ruff, prettier, stylua, shfmt)
- **Diagnostics:** Signs in gutter, no virtual text, float on `<space>q` with clickable Ruff rule links
- **Treesitter:** lua, python, bash, html, css, json, yaml, toml, vim, vimdoc
- **Venv detection:** [nvim-venv-detector](https://github.com/tnfru/nvim-venv-detector)

## Plugins (beyond NvChad defaults)

| Plugin | Purpose |
|--------|---------|
| hop.nvim | Jump motions (`f` = word, `F` = char, `<leader>j` menu) |
| dressing.nvim | Pretty floating input/select popups |
| fidget.nvim | LSP progress indicator |
| lazygit.nvim | LazyGit integration (`<leader>lg`) |
| nvim-notify | Notification popups |
| vim-tmux-navigator | Seamless tmux/nvim split navigation |
| mini.icons | File type icons |
| nvim-venv-detector | Auto-detect Python virtualenvs |

## Key Bindings

### Navigation
| Key | Action |
|-----|--------|
| `f` | Hop to word |
| `F` | Hop to character |
| `<leader>j` | Jump/Hop submenu |
| `<C-h/j/k/l>` | Navigate tmux/nvim splits |
| `H` / `L` | Scroll up/down |
| `<C-d>` / `<C-u>` | Half-page scroll (centered) |

### Diagnostics
| Key | Action |
|-----|--------|
| `<space>q` | Open diagnostic float (press number to open Ruff docs) |
| `<leader>dn` | Next diagnostic |
| `<leader>dp` | Previous diagnostic |
| `<leader>dd` | List all diagnostics |
| `<leader>dx` | Toggle diagnostics on/off |

### LSP
| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `<leader>ln` | Rename |
| `<leader>la` | Code action |
| `<leader>lf` | Format document |

### General
| Key | Action |
|-----|--------|
| `;` | Enter command mode |
| `jk` | Exit insert mode |
| `<C-s>` | Save |
| `<C-q>` | Quit |
| `<leader>sw` | Save without formatting |
| `<leader>lg` | Open LazyGit |
| Arrow keys | Resize splits |
