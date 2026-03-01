### Neovim Keymaps

- **leader key**: `space`

## General
- **Clear search**: `<Esc>`
- **Exit insert**: `jj`
- **Save file**: `<C-s>` (normal/insert/visual/select)
- **Disable arrows**: Arrow keys show hints to use `hjkl`

## Window navigation
- **Move focus**: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` (normal/visual)

## Diagnostics (built-in)
- **Prev/Next diagnostic**: `[d` / `]d`
- **Float diagnostics**: `<leader>e`
- **Diagnostics to loclist**: `<leader>q`

## LSP (buffer-local, on attach)
- **Go to definition**: `gd`
- **References**: `gr`
- **Implementations**: `gi`
- **Type definition**: `<leader>D`
- **Document symbols**: `<leader>cd`
- **Workspace symbols**: `<leader>cw`
- **Rename**: `<leader>cn`
- **Code action**: `<leader>ca`
- **Hover**: `K`
- **Restart LSP**: `<leader>rs`
- **Toggle inlay hints**: `<leader>th` (if supported)

## Telescope
- **Help tags**: `<leader>sh`
- **Keymaps**: `<leader>sk`
- **Find files**: `<leader>sf`
- **Builtin pickers**: `<leader>ss`
- **Grep current word**: `<leader>sw`
- **Live grep**: `<leader>sg`
- **Diagnostics**: `<leader>sd`
- **Resume**: `<leader>sr`
- **Recent files**: `<leader>s.`
- **Buffers**: `<leader><leader>`
- **Git files**: `<leader>sp`
- **Todos**: `<leader>st`
- **Treesitter symbols**: `<leader>sx`
- **Fuzzy in buffer**: `<leader>/`
- **Live grep open files**: `<leader>s/`
- **Search Neovim config**: `<leader>sn`

## Files (Neo-tree)
- **Toggle float**: `<leader>ef`
- **Toggle right sidebar**: `<leader>ee`

## Buffers (Barbar)
- **Prev/Next buffer**: `<A-,>` / `<A-.>`
- **Move buffer left/right**: `<A-<>` / `<A->>`
- **Go to 1..9 / last**: `<A-1>`..`<A-9>` / `<A-0>`
- **Pin buffer**: `<A-p>`
- **Close buffer**: `<A-c>`
- **Close others**: `<A-b>`

## Git (Gitsigns)
- **Next/Prev hunk**: `]c` / `[c`
- **Stage/Reset hunk**: `<leader>hs` / `<leader>hr` (visual range supported)
- **Stage buffer**: `<leader>hS`
- **Undo stage hunk**: `<leader>hu`
- **Reset buffer**: `<leader>hR`
- **Preview hunk**: `<leader>hp`
- **Blame line (full)**: `<leader>hb`
- **Toggle line blame**: `<leader>tb`
- **Diff (index)**: `<leader>hd`
- **Diff (against ~)**: `<leader>hD`
- **Toggle deleted**: `<leader>td`
- **Hunk text object**: `ih` (operator/visual)

## Diagnostics List (Trouble)
- **Workspace diagnostics**: `<leader>xw`
- **Buffer diagnostics**: `<leader>xd`
- **Quickfix list**: `<leader>xx`
- **Location list**: `<leader>xl`
- **Todos in Trouble**: `<leader>xt`

## Formatting
- **Format buffer**: `<leader>f` (via Conform)

## Substitute.nvim
- **Substitute with motion**: `s{motion}`
- **Substitute line**: `ss`
- **Substitute to EOL**: `S`
- **Substitute visual**: `s` (visual mode)

## Spectre (search/replace)
- **Toggle Spectre**: `<leader>fs`
- **Search current word**: `<leader>fw` (normal/visual)
- **Search in current file**: `<leader>fp`

## Copilot Chat
- **Toggle**: `<leader>aa`
- **Clear chat**: `<leader>ax`
- **Quick chat (prompt)**: `<leader>aq`
- **Submit (in chat buffer)**: `<leader>as`
- **Actions: Diagnostic help**: `<leader>ad`
- **Actions: Prompt presets**: `<leader>ap`
- **Generate commit (all changes)**: `<leader>am`
- **Generate commit (staged/all via diff)**: `<leader>ac`

## Sessions & Dashboard
- **Save session**: `<leader>qs`
- **Restore last session**: `<leader>ql`
- **Select session**: `<leader>qS`
- **Stop persistence**: `<leader>qd`
- **Open Dashboard**: `<leader>;`

## Flutter
- **Flutter commands picker**: `<leader>r`
- **Run build_runner**: `<leader>br`

## Go (filetype: go)
- **Import**: `<C-i>` (`:GoImport`)
- **Build package dir**: `<C-b>` (`:GoBuild %:h`)
- **Test package**: `<C-t>` (`:GoTestPkg`)
- **Coverage**: `<C-c>` (`:GoCoverage -p`)
