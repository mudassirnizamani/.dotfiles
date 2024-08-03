-- This Lua script is a configuration for the `nvim-surround` plugin for Neovim, a modern version of the Vim text editor. The `nvim-surround` plugin is designed to make it easier to work with "surroundings" in text, such as parentheses, brackets, quotes, XML tags, and more.
--
-- Here's a breakdown of the configuration:
--
-- - `"kylechui/nvim-surround"`: This is the GitHub repository where the plugin is hosted.
-- - `event = { "BufReadPre", "BufNewFile" }`: This specifies that the plugin should be loaded before a buffer is read (`BufReadPre`) and when a new file is created (`BufNewFile`).
-- - `version = "*"`: This indicates that any version of the plugin can be used. If this line was omitted, the `main` branch of the plugin would be used, which would include the latest features but might not be as stable.
-- - `config = true`: This means that the plugin should be configured. The actual configuration would be done elsewhere in the Neovim configuration files.

return {
	"kylechui/nvim-surround",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-textobjects"
	},
	event = { "BufReadPre", "BufNewFile" },
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	config = true,
}
