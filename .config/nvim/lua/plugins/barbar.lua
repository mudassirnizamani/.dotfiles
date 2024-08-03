-- This Lua file configures the Barbar.nvim plugin for Neovim. Barbar.nvim is a plugin that enhances the tabline/bufferline in Neovim.
--
-- ## Dependencies
--
-- This plugin depends on `lewis6991/gitsigns.nvim` for displaying git status.
--
-- ## Configuration
--
-- The plugin is configured with the following settings:
--
-- - `clickable`: This option enables or disables clickable tabs.
-- - `tabpages`: This option enables or disables the current/total tabpages indicator in the top right corner.
-- - `insert_at_end`: This option, when enabled, inserts new tabs at the end.
-- - `icons`: This option configures the icons displayed in the tabline. It includes options for the button icon, buffer index, file type, visibility, and git signs.
--
-- ## Key Mappings
--
-- The plugin also sets up several key mappings for managing buffers:
--
-- - `<A-,>` and `<A-.>`: Move to the previous or next buffer.
-- - `<A-<>` and `<A->>`: Re-order buffer to the previous or next position.
-- - `<A-1>` to `<A-9>`: Go to buffer in position 1 to 9.
-- - `<A-0>`: Go to the last buffer.
-- - `<A-p>`: Pin or unpin the current buffer.
-- - `<A-c>`: Close the current buffer.
-- - `<A-b>`: Close all buffers except the current one.
--
-- ## Usage
--
-- To use this configuration, include it in your Neovim configuration file. The plugin will be automatically set up with the specified settings and key mappings.
--
return {
	"romgrk/barbar.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- patched fonts support
		"lewis6991/gitsigns.nvim",   -- display git status
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	config = function()
		local barbar = require("barbar")

		barbar.setup({
			clickable = true, -- Enables/disables clickable tabs
			tabpages = false, -- Enable/disables current/total tabpages indicator (top right corner)
			insert_at_end = true,
			icons = {
				button = "",
				buffer_index = true,
				filetype = { enabled = true },
				visible = { modified = { buffer_number = false } },
				gitsigns = {
					added = { enabled = true, icon = "+" },
					changed = { enabled = true, icon = "~" },
					deleted = { enabled = true, icon = "-" },
				},
			},
		})

		-- key maps

		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		-- Move to previous/next
		map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
		map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
		-- Re-order to previous/next
		map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
		map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
		-- Goto buffer in position...
		map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
		map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
		map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
		map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
		map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
		map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
		map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
		map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
		map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
		map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
		-- Pin/unpin buffer
		map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
		-- Close buffer
		map("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
		map("n", "<A-b>", "<Cmd>BufferCloseAllButCurrent<CR>", opts)
	end,
}
