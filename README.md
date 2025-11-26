# Neovim Configuration

A modern, feature-rich Neovim configuration focused on productivity for full-stack development with AI-powered assistance.

## Features

### Core Functionality
- **Plugin Management**: [lazy.nvim](https://github.com/folke/lazy.nvim) for fast, lazy-loading plugin management
- **LSP Support**: Full Language Server Protocol integration via Mason
- **Autocompletion**: Intelligent completion with nvim-cmp and LuaSnip
- **Fuzzy Finding**: Fast file and text search with fzf-lua
- **Git Integration**: Gitsigns for inline git status and hunks
- **File Explorer**: Oil.nvim for buffer-based file management
- **AI Assistance**: Supermaven and Claude Code integration

### Language Support
- **TypeScript/JavaScript**: ts_ls, Tailwind CSS, HTML, CSS, Emmet
- **Python**: pylsp, Ruff (formatting & linting)
- **Lua**: lua_ls with Neovim-specific configuration
- **Go, Rust, Bash, SQL, JSON, Docker, and more**
- **Markdown**: Obsidian.nvim integration for note-taking
- **Typst**: Preview support for Typst documents

### Visual Enhancements
- **Theme**: Vague colorscheme with transparency
- **Syntax Highlighting**: Tree-sitter powered
- **Indent Guides**: Clear visual indentation lines
- **Color Highlighter**: Real-time color preview
- **Statusline**: Clean mini.statusline

### Productivity Tools
- **Harpoon**: Quick file navigation (mark up to 4 files)
- **Mini.nvim suite**: Auto-pairs, surround, comment, AI text objects
- **Tmux Navigation**: Seamless split navigation between Neovim and Tmux
- **Which-key**: Discover keybindings on the fly
- **Todo Comments**: Highlight TODO, FIXME, etc.

## Quick Start

### Prerequisites
- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional but recommended for icons)
- Node.js (for TypeScript/JavaScript LSP)
- Python 3 (for Python LSP)
- ripgrep (for fzf-lua search)

### Installation

#### 1. Backup existing config (if any)
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

#### 2. Clone this configuration
```bash
git clone git@github.com:d1373/neovim-config.git ~/.config/nvim
```

#### 3. Start Neovim
```bash
nvim
```

On first launch, lazy.nvim will automatically:
- Install itself
- Install all plugins
- Set up LSP servers via Mason

#### 4. Install LSP servers (automatic)
Open any file and LSP servers will install automatically via Mason. Or manually trigger:
```vim
:Mason
```

#### 5. Install external tools
```bash
# macOS
brew install ripgrep fd

# Ubuntu/Debian
sudo apt install ripgrep fd-find

# Arch
sudo pacman -S ripgrep fd
```

### For Obsidian Note-Taking
If you use Obsidian, set your vault path in `lua/doc.lua`:
```lua
workspaces = {
    {
        name = "notes",
        path = "~/Notes",  -- Change to your vault path
    },
},
```

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point, loads all modules
├── lua/
│   ├── set.lua          # Neovim options (tabs, line numbers, etc.)
│   ├── key.lua          # Custom keymaps
│   ├── plugins.lua      # General plugins (Oil, Harpoon, fzf)
│   ├── lsp.lua          # LSP configuration
│   ├── autocomplete.lua # Completion setup
│   ├── visual.lua       # Theme and visual plugins
│   ├── ai.lua           # AI tools (Supermaven, Claude Code)
│   ├── doc.lua          # Documentation tools (Obsidian, Typst)
│   ├── mini.lua         # Mini.nvim suite
│   ├── clipboard.lua    # Clipboard configuration
│   └── open.lua         # URL opener utility
└── README.md
```

## Key Bindings

### Leader Key
`Space` is the leader key for most commands.

### Essential Keybindings

#### File Navigation
| Key | Action |
|-----|--------|
| `<M-p>` | Find files |
| `<M-P>` | Find git files |
| `<M-s>` | Live grep (search in files) |
| `<M-o>` | Find files in Notes directory |
| `<leader>o` | Toggle Oil file explorer |

#### Harpoon (Quick File Switching)
| Key | Action |
|-----|--------|
| `<leader>a` | Add file to Harpoon |
| `<leader>e` | Toggle Harpoon menu |
| `<leader>h` | Jump to file 1 |
| `<leader>j` | Jump to file 2 |
| `<leader>k` | Jump to file 3 |
| `<leader>l` | Jump to file 4 |

#### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<leader>D` | Type definition |

#### Editing
| Key | Action |
|-----|--------|
| `<M-/>` | Toggle comment |
| `J/K` (visual) | Move lines up/down |
| `B` | Jump to line start (^) |
| `E` | Jump to line end ($) |
| `=/-` | Increment/decrement number |
| `<leader>sr` | Search & replace word under cursor |
| `<leader>S` | Global substitute |

#### Window Management
| Key | Action |
|-----|--------|
| `<C-b>` | Vertical split |
| `<C-h/j/k/l>` | Navigate splits (Tmux-aware) |
| `<M-Left/Right>` | Resize vertical split |
| `<M-Up/Down>` | Resize horizontal split |

#### AI Tools
| Key | Action |
|-----|--------|
| `<M-;>` | Accept Supermaven suggestion |
| `<C-;>` | Accept Supermaven word |
| `<leader>cc` | Toggle Claude Code |

#### Git
| Key | Action |
|-----|--------|
| `<leader>gp` | Preview git hunk |

#### Formatting
| Key | Action |
|-----|--------|
| `<M-i>` | Format buffer |

#### Obsidian Notes
| Key | Action |
|-----|--------|
| `<M-n>` | Create new note from template |
| `gf` | Follow link under cursor |
| `gk` | Open URL |

#### Utilities
| Key | Action |
|-----|--------|
| `<M-b>` | Open URL in browser |
| `<C-?>` | Search help tags |
| `<leader>?` | Show buffer keymaps |
| `<Esc>` | Clear search highlight |

## Customization

### Adding LSP Servers
Edit `lua/lsp.lua` and add to the `servers` table:
```lua
servers = {
    your_language_server = {},
    -- Add configuration here
}
```

### Changing Theme
Edit `lua/visual.lua` to use a different colorscheme.

### Modifying Keymaps
Edit `lua/key.lua` to customize keybindings.

### Adding Plugins
Add new plugins in the appropriate file:
- General plugins: `lua/plugins.lua`
- LSP-related: `lua/lsp.lua`
- Visual: `lua/visual.lua`
- AI tools: `lua/ai.lua`

## Installed LSP Servers

- **TypeScript/JavaScript**: ts_ls
- **Lua**: lua_ls
- **Python**: pylsp, ruff
- **JSON**: jsonls
- **SQL**: sqlls
- **Bash**: bashls
- **Typst**: tinymist
- **Docker**: dockerls, docker_compose_language_service
- **CSS/HTML**: cssls, html, tailwindcss, emmet_ls

## Formatters

- **Lua**: stylua
- **Python**: isort, black
- **JavaScript/TypeScript**: prettier/prettierd

## Tips

1. **First Launch**: Be patient while plugins and LSP servers install
2. **Mason**: Use `:Mason` to manage LSP servers and tools
3. **Lazy**: Use `:Lazy` to manage plugins
4. **Health Check**: Run `:checkhealth` to diagnose issues
5. **Help**: Press `<C-?>` to search Neovim help tags
6. **Which-key**: Press `<leader>` and wait to see available commands

## Troubleshooting

### LSP not working
1. Check `:LspInfo` to see attached servers
2. Verify installation with `:Mason`
3. Check `:checkhealth`

### Clipboard not working
Ensure you have clipboard support:
- macOS: Built-in
- Linux: Install `xclip` or `xsel`
- WSL: Requires win32yank

### Slow startup
Run `:Lazy profile` to see plugin loading times.

## Credits

This configuration is built on the shoulders of giants and inspired by:
- [ThePrimeagen](https://github.com/ThePrimeagen)
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- The Neovim community

## License

Feel free to use and modify this configuration as you see fit.
