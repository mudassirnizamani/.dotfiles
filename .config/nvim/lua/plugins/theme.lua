return {
  {
    "0xstepit/flow.nvim",
    lazy = false,
    priority = 5000,
    opts = {
      theme = {
        style = "dark",        -- "dark" | "light"
        contrast = "high",     -- "default" | "high" -> Boosted to high for better colors
        transparent = true     -- true | false
      },
      colors = {
        mode = "default",       -- "default" | "dark" | "light"
        fluo = "orange",       -- "pink" | "cyan" | "yellow" | "orange" | "green"
        custom = {
          saturation = "",     
          light = ""           
        }
      },
      ui = {
        borders = "inverse",      
        aggressive_spell = false  
      }
    },
    config = function(_, opts)
      require("flow").setup(opts)
      vim.cmd("colorscheme flow")

      -- Safely force transparent backgrounds without destroying foreground syntax colors!
      vim.cmd([[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalFloat guibg=NONE ctermbg=NONE
        hi NormalNC guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        hi CursorLineNr guibg=NONE ctermbg=NONE
        hi EndOfBuffer guibg=NONE ctermbg=NONE
      ]])

      -- The user noticed Function and Variable colors were "missing".
      -- Flow theme natively sets standard variables to plain gray (c.fg). 
      -- Let's override them with vibrant colors to match standard LazyVim expectations:
      vim.cmd([[
        hi @variable guifg=#c8d3f5
        hi @function guifg=#82aaff
        hi @function.call guifg=#82aaff
        hi @function.builtin guifg=#ff9e64
        hi @variable.parameter guifg=#ffc777
        hi @property guifg=#4fd6be
        hi @keyword guifg=#c099ff
        hi @type guifg=#ffcb6b
      ]])
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "flow",
    },
  },
}
