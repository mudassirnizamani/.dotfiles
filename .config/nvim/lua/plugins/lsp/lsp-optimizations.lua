-- LSP Performance Optimizations
-- This file contains settings to improve LSP performance

return {
	-- Optimize LSP performance
	{
		"neovim/nvim-lspconfig",
		init = function()
			-- Reduce updatetime for faster CursorHold events
			vim.o.updatetime = 100

			-- LSP Performance settings
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				opts.max_width = opts.max_width or 80
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

			-- Debounce diagnostics
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				float = {
					source = "always",
					border = "rounded",
				},
				signs = true,
				underline = true,
				update_in_insert = false, -- Don't update diagnostics in insert mode
				severity_sort = true,
			})

			-- LSP handlers with borders
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				width = 80,
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			-- Optimize file watcher
			local ok, wf = pcall(require, "vim.lsp._watchfiles")
			if ok then
				wf._watchfunc = function()
					return function() end
				end
			end
		end,
	},

	-- Faster startup with lazy loading
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", cmd = "Mason" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
	},

	-- Better performance for large files
	{
		"LunarVim/bigfile.nvim",
		event = "BufReadPre",
		opts = {
			filesize = 2, -- Size in MB
			pattern = { "*" },
			features = {
				"indent_blankline",
				"illuminate",
				"lsp",
				"treesitter",
				"syntax",
				"matchparen",
				"vimopts",
				"filetype",
			},
		},
	},
}