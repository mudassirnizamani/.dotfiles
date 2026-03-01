return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- Wrap mason setup in pcall for better error handling
		local mason_ok, mason = pcall(require, "mason")
		if not mason_ok then
			vim.notify("Failed to load mason.nvim", vim.log.levels.ERROR)
			return
		end

		local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
		if not mason_lspconfig_ok then
			vim.notify("Failed to load mason-lspconfig.nvim", vim.log.levels.ERROR)
			return
		end

		local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
		if not mason_tool_installer_ok then
			vim.notify("Failed to load mason-tool-installer.nvim", vim.log.levels.ERROR)
			return
		end

		-- enable mason and configure icons
		local setup_ok, err = pcall(function()
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				log_level = vim.log.levels.INFO,
				max_concurrent_installers = 4,
			})
		end)
		
		if not setup_ok then
			vim.notify("Mason setup failed: " .. tostring(err), vim.log.levels.ERROR)
			return
		end

		-- Note: mason-lspconfig is now handled in lspconfig.lua with handlers

		-- Install additional tools with better error handling
		local tool_install_ok, tool_err = pcall(function()
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"black", -- python formatter
					"pylint",
					"eslint_d",
					"ruff",
					"goimports", -- go formatter
					"gofumpt", -- go formatter
				},
				auto_update = false,
				run_on_start = true,
			})
		end)
		
		if not tool_install_ok then
			vim.notify("Mason tool installer setup failed: " .. tostring(tool_err), vim.log.levels.WARN)
		end
	end,
}
