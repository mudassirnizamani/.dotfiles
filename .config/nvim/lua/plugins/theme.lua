return {
  {
    'bluz71/vim-moonfly-colors',
    priority = 1000,
    init = function()
      -- vim.cmd.colorscheme 'moonfly'
    end,
  },
  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("flow").setup {
        transparent = true,       -- Set transparent background.
        fluo_color = "orange",    --  Fluo color: pink, yellow, orange, or green.
        mode = "normal",          -- Intensity of the palette: normal, bright, desaturate, or dark. Notice that dark is ugly!
        aggressive_spell = false, -- Display colors for spell check.
      }
      vim.cmd "colorscheme flow"
    end,
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
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
      -- vim.cmd("colorscheme kanagawa-wave")
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
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.opt.background = "dark" -- set this to dark or light
      -- vim.cmd.colorscheme "oxocarbon"
    end
  },
}
