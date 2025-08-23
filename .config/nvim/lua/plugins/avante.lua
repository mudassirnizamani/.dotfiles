return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	build = vim.fn.has("win32") ~= 0
		and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "Avante" },
			opts = { file_types = { "Avante" } },
			config = function(_, opts)
				require("render-markdown").setup(opts)
			end,
		},
	},
	opts = {
		-- Default to safe mode: no automatic edits
		mode = "legacy",
		-- Optionally disable risky tools even if agentic is enabled
		disabled_tools = { "bash", "python" },
					selector = {
				exclude_auto_select = { "NvimTree" },
			},
			disabled_providers = { "copilot" },
		-- Project-specific instructions file (optional)
		instructions_file = "avante.md",
		-- Default provider and available providers
		provider = "gpt5",
		providers = {
			gpt5 = { __inherited_from = "openai",
				endpoint = "https://api.openai.com/v1",
				model = "o4-mini",
				timeout = 30000,
									extra_request_body = {
						temperature = 1,
						max_completion_tokens = 8192,
					},
			},
			gemini = { __inherited_from = "gemini",
				endpoint = "https://generativelanguage.googleapis.com",
				model = "gemini-2.5-pro",
				timeout = 30000,
				api_key_name = "GOOGLE_API_KEY",
				extra_request_body = {
					temperature = 0.7,
					max_output_tokens = 8192,
				},
			},

		},
	},
	config = function(_, opts)
		local avante = require("avante")
		avante.setup(opts)

		-- Patch: guard debounced_show_input_hint against 'handle is already closing'
		pcall(function()
			local utils = require("avante.utils")
			local orig = utils.debounced_show_input_hint
			if type(orig) == "function" then
				utils.debounced_show_input_hint = function(...)
					local ok, err = pcall(orig, ...)
					if not ok and type(err) == "string" and err:find("already closing") then
						return
					end
					if not ok then error(err) end
					return err
				end
			end
		end)

		-- Helper to switch modes safely at runtime
		local function set_mode(mode)
			local ok, cfg = pcall(require, "avante.config")
			if ok and type(cfg) == "table" then
				cfg.mode = mode
			else
				-- Fallback: re-run setup merging the new mode
				avante.setup(vim.tbl_deep_extend("force", opts or {}, { mode = mode }))
			end
			vim.notify("Avante mode: " .. mode)
		end

		-- Only allow edits when explicitly enabled
		vim.keymap.set("n", "<leader>ae", function()
			set_mode("agentic")
		end, { desc = "Avante: enable agentic (allow edits)" })

		-- Go back to safe mode (no auto-edits)
		vim.keymap.set("n", "<leader>ad", function()
			set_mode("legacy")
		end, { desc = "Avante: legacy mode (no auto edits)" })

		-- Open/Toggle Avante chat UI (falls back to :Avante if available)
		vim.keymap.set("n", "<leader>ao", function()
			if vim.fn.exists(":Avante") == 2 then
				vim.cmd("Avante")
			else
				pcall(function() require("avante").toggle() end)
			end
		end, { desc = "Avante: open/toggle chat" })

		-- Ask (normal/visual). Uses :AvanteAsk if available, otherwise calls API if present
		local function avante_ask()
			if vim.fn.exists(":AvanteAsk") == 2 then
				vim.cmd("AvanteAsk")
				return
			end
			pcall(function() require("avante").ask() end)
		end
		vim.keymap.set({ "n", "v" }, "<leader>ax", avante_ask, { desc = "Avante: ask (uses selection if visual)" })

		-- Model picker (simple toggle between gpt5 and gemini to avoid copilot list)
		vim.keymap.set("n", "<leader>am", function()
			local ok, cfg = pcall(require, "avante.config")
			if not ok or type(cfg) ~= "table" then
				vim.notify("Avante: config not available", vim.log.levels.WARN)
				return
			end
			local current = cfg.provider or "gpt5"
			local nextp = current == "gpt5" and "gemini" or "gpt5"
			cfg.provider = nextp
			vim.notify("Avante provider: " .. nextp)
		end, { desc = "Avante: toggle provider (gpt5↔gemini)" })

		-- Copy helper: open current Avante sidebar buffer contents in a scratch split for copying
		vim.keymap.set("n", "<leader>aC", function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.bo[buf].filetype
				if ft == "Avante" then
					local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
					vim.cmd("botright new")
					local nbuf = vim.api.nvim_get_current_buf()
					vim.bo[nbuf].buftype = "nofile"
					vim.bo[nbuf].bufhidden = "wipe"
					vim.bo[nbuf].swapfile = false
					vim.bo[nbuf].filetype = "markdown"
					vim.api.nvim_buf_set_lines(nbuf, 0, -1, false, lines)
					vim.notify("Avante: opened copy buffer at bottom")
					return
				end
			end
			vim.notify("Avante: sidebar not found", vim.log.levels.WARN)
		end, { desc = "Avante: open copyable buffer" })

		-- Selected files viewer at bottom (tracks NvimTree selections)
		local selected = {}
		local function refresh_selected_view()
			if not vim.g.avante_selected_buf or not vim.api.nvim_buf_is_valid(vim.g.avante_selected_buf) then return end
			local list = {}
			for path, ok in pairs(selected) do if ok then table.insert(list, path) end end
			table.sort(list)
			vim.api.nvim_buf_set_lines(vim.g.avante_selected_buf, 0, -1, false, list)
		end
		vim.keymap.set("n", "<leader>ab", function()
			if vim.g.avante_selected_win and vim.api.nvim_win_is_valid(vim.g.avante_selected_win) then
				vim.api.nvim_win_close(vim.g.avante_selected_win, true)
				vim.g.avante_selected_win, vim.g.avante_selected_buf = nil, nil
				return
			end
			vim.cmd("botright 8new")
			vim.g.avante_selected_win = vim.api.nvim_get_current_win()
			vim.g.avante_selected_buf = vim.api.nvim_get_current_buf()
			vim.bo[vim.g.avante_selected_buf].buftype = "nofile"
			vim.bo[vim.g.avante_selected_buf].bufhidden = "wipe"
			vim.bo[vim.g.avante_selected_buf].swapfile = false
			vim.bo[vim.g.avante_selected_buf].filetype = "avante_selected"
			refresh_selected_view()
		end, { desc = "Avante: toggle selected files box (bottom)" })

		-- Replace NvimTree integration: use Neo-tree node under cursor for selecting/deselecting files
		local function get_neotree_path()
			local ok, sources = pcall(require, "neo-tree.sources.filesystem")
			if not ok then return nil end
			local state = sources.get_state()
			if not state or not state.tree or not state.tree:get_node() then return nil end
			local node = state.tree:get_node()
			return node and node:get_id() or nil
		end
		vim.keymap.set("n", "<leader>a+", function()
			-- Attempt Avante's extension first if present
			pcall(function() require("avante.extensions.nvim_tree").add_file() end)
			local p = get_neotree_path()
			if p then selected[p] = true refresh_selected_view() end
		end, { desc = "Avante: select file (Neo-tree)" })
		vim.keymap.set("n", "<leader>a-", function()
			pcall(function() require("avante.extensions.nvim_tree").remove_file() end)
			local p = get_neotree_path()
			if p then selected[p] = nil refresh_selected_view() end
		end, { desc = "Avante: deselect file (Neo-tree)" })
	end,
} 