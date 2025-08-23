return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
					opts = {
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				cmdline = { view = "cmdline" },
				notify = { enabled = false },
				messages = { enabled = false },
				popupmenu = { enabled = false },
				presets = { lsp_doc_border = true },
			},
		config = function(_, opts)
			require("noice").setup(opts)
			vim.keymap.set("n", "<leader>nh", ":Noice history<CR>", { silent = true, desc = "Noice history" })
			vim.keymap.set("n", "<leader>nd", ":Noice dismiss<CR>", { silent = true, desc = "Noice dismiss" })
		end,
	},
	{
		"stevearc/aerial.nvim",
		cmd = { "AerialToggle", "AerialOpen" },
		opts = {
			backends = { "lsp", "treesitter", "markdown" },
			attach_mode = "global",
			show_guides = true,
		},
		config = function(_, opts)
			require("aerial").setup(opts)
			vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Symbols outline" })
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async" },
		opts = {},
		config = function()
			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					if buftype ~= "" or filetype == "neo-tree" or filetype == "Avante" or filetype == "TelescopePrompt" then
						return ""
					end
					return { "treesitter", "indent" }
				end,
			})
			vim.keymap.set("n", "zK", function() require("ufo").peekFoldedLinesUnderCursor() end,
				{ desc = "Peek fold" })
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
	},
} 