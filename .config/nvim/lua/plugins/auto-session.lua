-- # Documentation for `auto-session.lua`
--
-- This Lua script is a configuration file for the `auto-session` plugin in Neovim. The `auto-session` plugin is used to automatically save and restore sessions in Neovim.
--
--
-- ## Keybindings
--
-- The `<leader>wr` keybinding is used to restore the last workspace session for the current directory.
--
-- The `<leader>ws` keybinding is used to save the workspace session for the current working directory.
return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })           -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
	end,
}
