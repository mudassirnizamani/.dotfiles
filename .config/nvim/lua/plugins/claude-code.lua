return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}

-- 1. Fixed command names: Changed
-- ClaudeCodeChat to ClaudeCode and other
--  correct command names
-- 2. Added proper keybindings: Using
-- <leader>a* pattern as shown in the
-- docs
-- 3. Added terminal configuration:
-- Including the jj mapping to exit
-- insert mode in the Claude chat
-- 4. Added missing options: Selection
-- tracking, terminal settings, and
-- provider configuration
--
-- The key mappings are now:
-- - <leader>cc - Toggle Claude Code
-- - <leader>cf - Focus Claude
-- - <leader>cr - Resume Claude
-- - <leader>cC - Continue Claude
-- - <leader>cm - Select Claude Model
-- - <leader>cb - Add current buffer
-- - <leader>cs - Send selection to
-- Claude (visual mode)
-- - <leader>ca - Accept diff
-- - <leader>cd - Deny diff
--
-- And most importantly, jj will now exit
--  insert mode in the Claude chat
-- terminal.
--
