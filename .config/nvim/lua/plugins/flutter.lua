-- Flutter/Dart: LSP, FlutterRun, syntax highlighting
-- Placed at top-level so Lazy reliably loads it
return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = { border = "rounded", notification_style = "native" },
        decorations = {
          statusline = { app_version = true, device = true, project_config = true },
        },
        debugger = { enabled = false, run_via_dap = false, exception_breakpoints = {} },
        root_patterns = { ".git", "pubspec.yaml" },
        fvm = false,
        -- Use explicit flutter path instead of shell lookup
        flutter_path = "/home/mahapara/binaries/flutter/bin/flutter",
        widget_guides = { enabled = false },
        closing_tags = { highlight = "Comment", prefix = "//", enabled = true },
        dev_log = { enabled = true, notify_errors = false, open_cmd = "tabedit" },
        dev_tools = { autostart = false, auto_open_browser = false },
        outline = { open_cmd = "30vnew", auto_open = false },
        lsp = {

          capabilities = function(config)
            local ok, cmp = pcall(require, "cmp_nvim_lsp")
            if ok and cmp then
              config = vim.tbl_deep_extend("force", config, cmp.default_capabilities())
            end
            return config
          end,
          analysisExcludedFolders = { "./fvm/" },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            updateImportsOnRename = true,
          },
        },
      })
      pcall(function()
        require("telescope").load_extension("flutter")
        vim.keymap.set("n", "<leader>r", require("telescope").extensions.flutter.commands, {
          desc = "Flutter commands",
        })
      end)
      vim.keymap.set("n", "<leader>br", function()
        vim.cmd("20new")
        vim.cmd("te flutter packages pub run build_runner build --delete-conflicting-outputs")
        vim.cmd("2sleep | normal G")
      end, { desc = "Build runner" })
    end,
  },
  -- Dart syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dart" } },
  },
}
