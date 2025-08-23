return {
	{
		"gbprod/yanky.nvim",
		event = { "BufReadPost", "BufNewFile" },
					opts = {
				ring_history = { length = 100 },
			},
		config = function(_, opts)
			require("yanky").setup(opts)
			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
			vim.keymap.set("n", "<leader>y", ":Telescope yank_history<CR>", { silent = true, desc = "Yank history" })
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		opts = {
			patterns = { ".git", "package.json", "go.mod", "pyproject.toml", "Cargo.toml" },
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)
			pcall(require("telescope").load_extension, "projects")
			vim.keymap.set("n", "<leader>pp", ":Telescope projects<CR>", { silent = true, desc = "Projects" })
		end,
	},
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "VeryLazy",
		config = function()
			require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_text = false })
			vim.keymap.set("n", "<leader>tl", function()
				local enabled = not vim.diagnostic.config().virtual_text
				vim.diagnostic.config({ virtual_text = enabled })
				vim.api.nvim_command(enabled and "LspLinesDisable" or "LspLinesEnable")
			end, { desc = "Toggle lsp_lines" })
		end,
	},
} 