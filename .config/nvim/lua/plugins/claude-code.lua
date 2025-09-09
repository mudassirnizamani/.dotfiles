return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      terminal = {
        position = "vertical",   -- Use vertical split (opens on the side)
        size = 60,              -- Width when using vertical split
      }
    })
    
    -- Custom keybindings for Claude Code
    vim.keymap.set("n", "<leader>cca", ":ClaudeCode<CR>", { desc = "Toggle Claude Code Terminal" })
    vim.keymap.set("n", "<leader>ccc", ":ClaudeCodeContinue<CR>", { desc = "Claude Code Continue - Resume recent conversation" })
    vim.keymap.set("n", "<leader>ccr", ":ClaudeCodeResume<CR>", { desc = "Claude Code Resume - Display conversation picker" })
  end
}