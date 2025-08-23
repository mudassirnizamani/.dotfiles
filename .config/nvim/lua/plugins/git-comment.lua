return {
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		config = function()
			vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { silent = true, desc = "Diffview Open" })
			vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", { silent = true, desc = "Diffview Close" })
			vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { silent = true, desc = "Diffview File History" })
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
} 