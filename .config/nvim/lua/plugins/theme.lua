return {
  -- themes
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'bluz71/vim-moonfly-colors',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'moonfly'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("flow").setup {
        transparent = false,      -- Set transparent background.
        fluo_color = "pink",      --  Fluo color: pink, yellow, orange, or green.
        mode = "normal",          -- Intensity of the palette: normal, bright, desaturate, or dark. Notice that dark is ugly!
        aggressive_spell = false, -- Display colors for spell check.
      }

      -- vim.cmd "colorscheme flow"
    end,
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      -- vim.cmd [[colorscheme tokyodark]]
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd("colorscheme cyberdream")
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      vim.cmd("colorscheme kanagawa-wave")
    end
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    config = function()
      require('onedark').setup {
        style = 'warmer'
      }

      -- vim.cmd("colorscheme onedark")
    end
  }
}
