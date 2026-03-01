### Developer Tools Enhancements

## Clipboard & Navigation
- yanky.nvim: Better pasting (`p`/`P`) and searchable yank history (`<leader>y`).
- project.nvim: `<leader>pp` to jump across projects; sets cwd automatically.

## Diagnostics
- lsp_lines.nvim: Inline diagnostics for active fixing; toggle with `<leader>tl`.

## Debugging
- nvim-dap + dap-ui + virtual-text: Real debugger with UI panes and inline values.
- Keys: `<F5>` continue, `<F10>/<F11>/<F12>` step, `<leader>db` toggle BP, `<leader>dB` conditional BP, `<leader>du` UI.
- mason-nvim-dap installs adapters automatically (Python, Go delve, JS). Open `:Mason` to check.

## Git & Reviews
- diffview.nvim: PR-style side-by-side diffs.
  - `<leader>gd` open, `<leader>gD` close, `<leader>gh` file history.
- Comment.nvim: `gc` to toggle comments (motions/visual supported).

## Tips
- Combine yank history with diffview to stage and refine changes.
- Keep lsp_lines off generally (virtual_text on), and enable it when triaging errors.