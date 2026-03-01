return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	opts = {
		enabled = false,
		message_template = "<author> • <date> • <summary>",
		date_format = "%Y-%m-%d",
	},
	config = function(_, opts)
		local ok, gitblame = pcall(require, "gitblame")
		if not ok then return end
		gitblame.setup(opts)
		vim.keymap.set("n", "<leader>tb", function()
			vim.g.gitblame_enabled = not vim.g.gitblame_enabled
			if vim.g.gitblame_enabled then
				vim.notify("git-blame: on")
			else
				vim.notify("git-blame: off")
			end
		end, { desc = "Toggle git blame virtual text" })
	end,
}
