--
-- The `substitute.nvim` plugin enhances the substitution functionality in Neovim. It provides several features:
--
-- 1. **Substitute with motion**: This allows you to substitute a string within a range defined by a motion. For example, if you type `s` followed by a motion command like `w` (word), it will substitute the string in the next word.
--
-- 2. **Substitute line**: This allows you to substitute a string in the entire current line. You can activate this feature by typing `ss`.
--
-- 3. **Substitute to end of line**: This allows you to substitute a string from the current cursor position to the end of the line. You can activate this feature by typing `S`.
--
-- 4. **Substitute in visual mode**: This allows you to substitute a string within a visually selected area. You can activate this feature by typing `s` in visual mode.
return {
	"gbprod/substitute.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local substitute = require("substitute")

		substitute.setup()

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
		keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
		keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
		keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
	end,
}
