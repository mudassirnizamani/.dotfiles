return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 2000,
    config = function()
      require('ayu').setup({
        mirage = false,  -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        terminal = true, -- Set to `false` to let terminal manage its own colors.
        overrides = {},  -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
      })

      vim.cmd("colorscheme ayu")
    end
  },
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
    priority = 5000,
    opts = {
      transparent = true,    -- Set transparent background.
      fluo_color = "orange", --  Fluo color: pink, yellow, orange, or green.
      mode = "bright",       -- Intensity of the palette: normal, bright, desaturate, or dark. Notice that dark is ugly!

      theme = {
        style = "dark",    --  "dark" | "light"
        contrast = "high", -- "default" | "high"
      },
      colors = {
        custom = {
          saturation = "0", -- "" | string representing an integer between 0 and 100
          light = "0",      -- "" | string representing an integer between 0 and 100
        },
      },
      ui = {
        borders = "inverse",      -- "theme" | "inverse" | "fluo" | "none"
        aggressive_spell = false, -- true | false
      },
    },
    config = function(_, opts)
      require("flow").setup(opts)
      -- vim.cmd "colorscheme flow"
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
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.opt.background = "dark" -- set this to dark or light
      -- vim.cmd.colorscheme "oxocarbon"
    end
  },
  {
    "ramojus/mellifluous.nvim",
    -- version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
    config = function()
      require("mellifluous").setup({}) -- optional, see configuration section.
      -- vim.cmd("colorscheme mellifluous tender")
    end,
  },
  {
    'marko-cerovac/material.nvim',
    lazy = false,
    config = function()
      require("material").setup({
        styles = { -- Give comments style such as bold, italic, underline etc.
          comments = { italic = true },
          strings = { --[[ bold = true ]] },
          keywords = { --[[ underline = true ]] },
          functions = { --[[ bold = true, undercurl = true ]] },
          variables = {},
          operators = {},
          types = {},
        },

        lualine_style = "stealth"
      }) -- optional, see configuration section.

      -- vim.cmd('colorscheme material')
      -- vim.g.material_style = "palenight"
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      -- vim.o.background = "dark" -- or "light" for light mode
      -- vim.cmd('colorscheme gruvbox')
    end
  },
  {
    'eddyekofo94/gruvbox-flat.nvim',
    priority = 1000,
    enabled = true,
    lazy = false,
    config = function()
      vim.g.gruvbox_flat_style = "hard"
      -- vim.cmd('colorscheme gruvbox-flat')
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = false,               -- Disable setting background
          terminal_colors = false,           -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false,              -- Non focused panes set to alternative background
          module_default = true,             -- Default enable value for modules
          colorblind = {
            enable = false,                  -- Enable colorblind support
            simulate_only = false,           -- Only show simulated colorblind colors and not diff shifted
            severity = {
              protan = 0,                    -- Severity [0,1] for protan (red)
              deutan = 0,                    -- Severity [0,1] for deutan (green)
              tritan = 0,                    -- Severity [0,1] for tritan (blue)
            },
          },
          styles = {           -- Style to be applied to different syntax groups
            comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = { -- List of various plugins and additional options
            -- ...
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })

      -- vim.cmd("colorscheme duskfox")
    end
  },
}
