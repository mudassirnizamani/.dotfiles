-- This Lua script is a configuration file for the `nvim-autopairs` plugin in Neovim. It sets up automatic pairing of brackets, quotes, and other characters in your Neovim editor.
--
--
-- This configuration ensures that the `nvim-autopairs` plugin works correctly with the `nvim-cmp` plugin, and that it respects the specific configuration for different programming languages.

return {
	"windwp/nvim-autopairs",
	event = { "InsertEnter" },

	config = function()
		-- import nvim-autopairs
		local autopairs = require("nvim-autopairs")

		-- configure autopairs
		autopairs.setup({
			check_ts = true,                  -- enable treesitter
			ts_config = {
				lua = { "string" },             -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
				java = false,                   -- don't check treesitter on java
			},
		})

	end,
}
