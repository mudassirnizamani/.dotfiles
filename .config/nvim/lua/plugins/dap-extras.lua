return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local dap = require("dap")
			pcall(require, "nio") -- ensure nvim-nio is loaded before dap-ui
			local dapui = require("dapui")
			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			require("mason-nvim-dap").setup({
				automatic_setup = true,
				ensure_installed = { "debugpy", "delve", "js-debug-adapter" },
				handlers = {},
			})

			-- Open/close UI automatically
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

			-- Keymaps
			vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
			vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
			vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
			vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
			vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
				{ desc = "DAP Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI Toggle" })
		end,
	},
} 