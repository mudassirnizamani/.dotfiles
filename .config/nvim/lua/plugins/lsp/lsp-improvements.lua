return {
	-- 1. Incremental LSP rename with preview
	{
		"smjonas/inc-rename.nvim",
		event = "LspAttach",
		opts = {},
		config = function(_, opts)
			require("inc-rename").setup(opts)
			vim.keymap.set("n", "<leader>cr", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true, desc = "Incremental rename" })
		end,
	},

	-- 2. Better LSP UI with hover actions
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		opts = {
			symbol_in_winbar = { enable = false },
			lightbulb = { enable = false },
			outline = { auto_preview = false },
			code_action = { show_server_name = true },
		},
		config = function(_, opts)
			require("lspsaga").setup(opts)
			-- Enhanced keymaps
			vim.keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "LSP finder" })
			vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outline<CR>", { desc = "Code outline" })
			vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
			vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })
			vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>Lspsaga code_action<CR>", { desc = "Code action (Saga)" })
			vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { desc = "Incoming calls" })
			vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "Outgoing calls" })
		end,
	},

	-- 3. Signature help while typing
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = { border = "rounded" },
			floating_window = true,
			floating_window_above_cur_line = true,
			hint_enable = false,
			toggle_key = "<C-k>",
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},

	-- 4. Better diagnostics with virtual text at end of line
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_lines").setup()
			-- Start with lsp_lines disabled, toggle with <leader>tl
			vim.diagnostic.config({ virtual_lines = false })
		end,
	},

	-- 5. Show function context in winbar
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		opts = {
			lsp = {
				auto_attach = true,
				preference = { "vtsls", "pyright", "gopls", "lua_ls" },
			},
			highlight = true,
			click = true,
		},
	},

	-- 6. Better TypeScript tools (if you work with TS)
	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			settings = {
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
				},
			},
		},
	},

	-- 7. Show lightbulb for code actions
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
			sign = { enabled = false },
			virtual_text = { enabled = true, text = "💡" },
		},
	},

	-- 8. Better folding based on LSP
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		opts = {
			provider_selector = function()
				return { "lsp", "indent" }
			end,
		},
		config = function(_, opts)
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup(opts)
			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek fold" })
		end,
	},

	-- 9. Inline diagnostics with more details
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "powerline",
				options = {
					show_source = true,
					multilines = true,
					show_all_diags_on_cursorline = true,
				},
			})
		end,
	},
}