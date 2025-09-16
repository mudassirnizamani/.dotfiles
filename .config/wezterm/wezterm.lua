-- WezTerm Configuration with Ghostty-like keybindings and Rose Pine theme
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ====================================
-- APPEARANCE - Rose Pine Theme
-- ====================================
config.color_scheme = 'rose-pine'
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font_size = 14.5

-- Window appearance
config.window_background_opacity = 0.93
config.window_decorations = 'RESIZE'
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

-- Remove padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Rose Pine colors for UI elements
config.colors = {
  tab_bar = {
    background = '#191724',
    active_tab = {
      bg_color = '#31748f',
      fg_color = '#e0def4',
    },
    inactive_tab = {
      bg_color = '#26233a',
      fg_color = '#6e6a86',
    },
    inactive_tab_hover = {
      bg_color = '#403d52',
      fg_color = '#e0def4',
    },
  },
}

-- ====================================
-- GHOSTTY-COMPATIBLE KEYBINDINGS
-- ====================================
local act = wezterm.action

config.keys = {
  -- ===== TAB MANAGEMENT (Same as Ghostty) =====
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },

  -- Tab navigation (Ctrl+1-9 for window switching)
  { key = '1', mods = 'CTRL', action = act.ActivateTab(0) },
  { key = '2', mods = 'CTRL', action = act.ActivateTab(1) },
  { key = '3', mods = 'CTRL', action = act.ActivateTab(2) },
  { key = '4', mods = 'CTRL', action = act.ActivateTab(3) },
  { key = '5', mods = 'CTRL', action = act.ActivateTab(4) },
  { key = '6', mods = 'CTRL', action = act.ActivateTab(5) },
  { key = '7', mods = 'CTRL', action = act.ActivateTab(6) },
  { key = '8', mods = 'CTRL', action = act.ActivateTab(7) },
  { key = '9', mods = 'CTRL', action = act.ActivateTab(8) },

  -- Tab switching (same as Ghostty)
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },

  -- ===== PANE MANAGEMENT (SIDEBAR FUNCTIONALITY) =====
  -- Create splits (matching your Ghostty config)
  { key = 's', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- Left sidebar
  { key = 'd', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },   -- Right sidebar
  { key = 'o', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- Ghostty compat
  { key = 'e', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },   -- Bottom split

  -- Navigate panes (matching your Ghostty navigation)
  { key = 'h', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Down' },

  -- Also support arrow keys for pane navigation
  { key = 'LeftArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Down' },

  -- Pane management
  { key = 'Enter', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState }, -- Focus single pane
  { key = 'x', mods = 'CTRL|ALT', action = act.CloseCurrentPane { confirm = true } },

  -- ===== ADDITIONAL FEATURES =====
  -- Fullscreen toggle (same as Ghostty)
  { key = 'Enter', mods = 'CTRL', action = act.ToggleFullScreen },

  -- Copy/Paste (matching Ghostty)
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Font size adjustment
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },

  -- ===== SIDEBAR-SPECIFIC FEATURES =====
  -- Quick sidebar with file manager
  {
    key = 'e',
    mods = 'CTRL|ALT',
    action = act.SplitHorizontal {
      domain = 'CurrentPaneDomain',
    },
  },

  -- Quick sidebar with system monitor
  {
    key = 'm',
    mods = 'CTRL|ALT',
    action = act.SplitVertical {
      domain = 'CurrentPaneDomain',
    },
  },

  -- Quick sidebar with git
  {
    key = 'g',
    mods = 'CTRL|ALT',
    action = act.SplitVertical {
      domain = 'CurrentPaneDomain',
    },
  },
}

-- ====================================
-- ADVANCED FEATURES
-- ====================================

-- Enable scrollback
config.scrollback_lines = 100000

-- Enable shell integration
config.set_environment_variables = {
  TERM = 'wezterm',
}

-- Startup behavior
config.initial_cols = 120
config.initial_rows = 30

-- Disable annoying features
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

-- ====================================
-- MULTIPLEXER FEATURES
-- ====================================

-- Session management
config.default_workspace = 'main'

-- Configure tab bar
config.tab_max_width = 25
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true

return config