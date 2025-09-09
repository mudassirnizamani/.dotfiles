return {
  {                   -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      local wk = require('which-key')
      wk.setup({
        plugins = { spelling = true },
        win = { border = 'single' },
        layout = { align = 'left' },
        show_help = true,
        show_keys = true,
        triggers = { '<leader>' },
      })

      -- Document key groups so pressing <leader> shows organized sections
      wk.add({
        { '<leader>a', group = '[A]vante' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>cc', group = 'Claude Code' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>e', group = '[E]xplorer' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>g', group = '[G]it' },
        { '<leader>h', group = 'Git [H]unk' },
        { '<leader>n', group = '[N]otifications' },
        { '<leader>p', group = '[P]rojects' },
        { '<leader>q', group = '[Q]ession' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>x', group = 'Trouble' },
        { '<leader>y', group = '[Y]ank' },
        -- visual mode
        { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
      })
    end,
  },

}
