return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = { char = "┊" },
	},
}
-- return {
-- 	"lukas-reineke/indent-blankline.nvim",
-- 	main = "ibl",
-- 	opts = {},
-- 	config = function()
-- 		require("ibl").setup()
-- 	end
-- }
