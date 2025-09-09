# LSP Keybindings Reference

## Navigation
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `gd` | Go to definition | Telescope LSP |
| `gr` | Go to references | Telescope LSP |
| `gi` | Go to implementation | Telescope LSP |
| `gD` | Go to declaration | Native LSP |
| `gp` | Peek definition (floating window) | LSP Saga |
| `gt` | Peek type definition | LSP Saga |
| `gh` | LSP finder (refs, defs, impls) | LSP Saga |
| `<leader>D` | Type definition | Telescope LSP |

## Code Actions & Refactoring
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>ca` | Code action | Native LSP |
| `<leader>cc` | Enhanced code action | LSP Saga |
| `<leader>cn` | Rename symbol | Native LSP |
| `<leader>cr` | Incremental rename with preview | inc-rename |
| `K` | Hover documentation | Native LSP |
| `<C-k>` | Signature help (insert mode) | lsp_signature |

## Symbols & Outline
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>cd` | Document symbols | Telescope LSP |
| `<leader>cw` | Workspace symbols | Telescope LSP |
| `<leader>co` | Code outline | LSP Saga |

## Call Hierarchy
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>ci` | Incoming calls | LSP Saga |
| `<leader>co` | Outgoing calls | LSP Saga |

## Diagnostics
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>xw` | Workspace diagnostics | Trouble |
| `<leader>xd` | Document diagnostics | Trouble |
| `<leader>xx` | Quickfix list | Trouble |
| `<leader>xl` | Location list | Trouble |
| `<leader>xt` | TODOs | Trouble |
| `<leader>tl` | Toggle LSP lines (inline diagnostics) | lsp_lines |
| `[d` | Previous diagnostic | Native |
| `]d` | Next diagnostic | Native |

## Folding
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `zR` | Open all folds | nvim-ufo |
| `zM` | Close all folds | nvim-ufo |
| `zK` | Peek fold | nvim-ufo |
| `za` | Toggle fold | Native |
| `zo` | Open fold | Native |
| `zc` | Close fold | Native |

## Utilities
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>rs` | Restart LSP | Native LSP |
| `<leader>th` | Toggle inlay hints | Native LSP |
| `:Mason` | Open Mason UI | Mason |
| `:LspInfo` | Show LSP info | Native LSP |
| `:Lazy sync` | Update plugins | Lazy.nvim |

## Completion (Insert Mode)
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<C-Space>` | Trigger completion | nvim-cmp |
| `<C-j>` | Next completion item | nvim-cmp |
| `<C-k>` | Previous completion item | nvim-cmp |
| `<CR>` | Confirm completion | nvim-cmp |
| `<C-e>` | Abort completion | nvim-cmp |
| `<C-f>` | Scroll docs forward | nvim-cmp |
| `<C-b>` | Scroll docs backward | nvim-cmp |
| `<Tab>` | Jump to next snippet placeholder | LuaSnip |
| `<S-Tab>` | Jump to previous snippet placeholder | LuaSnip |

## Git Integration
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>gb` | Git blame | git-blame |
| `<leader>gs` | Git status | Telescope |
| `<leader>gc` | Git commits | Telescope |
| `<leader>gf` | Git files | Telescope |

## File Navigation
| Keybinding | Description | Plugin |
|------------|-------------|--------|
| `<leader>ff` | Find files | Telescope |
| `<leader>fg` | Live grep | Telescope |
| `<leader>fb` | Buffers | Telescope |
| `<leader>fh` | Help tags | Telescope |
| `<leader>e` | File explorer | NeoTree/NvimTree |