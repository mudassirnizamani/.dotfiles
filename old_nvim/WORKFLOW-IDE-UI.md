### IDE UI Enhancements

This setup adds a modern UI/UX layer over core Neovim.

## noice.nvim (+ notify)
- Replaces noisy messages with a clean commandline and popups.
- LSP hover/signature markdown is rendered crisply.
- Use `<leader>nh` to review message history; `<leader>nd` to dismiss.

## aerial.nvim (Symbols Outline)
- Global outline of functions/types/sections from LSP/Tree-sitter.
- Toggle with `<leader>o`. Jump to a symbol with Enter; keeps context for large files.

## ufo.nvim (Smart Folding)
- Leverages LSP/TS for robust folding, preserves state.
- Peek folded code under cursor with `zK` without unfolding.

## rainbow-delimiters
- Colorizes nested brackets/parens for quick scope parsing, especially in C/C++/TS.

## Tips
- Pair Aerial with Telescope for quick symbol fuzzy search.
- Use folds to collapse long regions (tests/vendor) and focus your edits.

</rewritten_file>