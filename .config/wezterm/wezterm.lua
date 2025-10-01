-- WezTerm Configuration with Ghostty-like keybindings and Neofusion theme
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux

-- ====================================
-- APPEARANCE - Neofusion Theme
-- ====================================
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
config.font_size = 13.6

-- Window appearance
config.window_background_opacity = 0.75
config.window_decorations = 'NONE'
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Remove all padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Dark theme matching Neovim
local dark_theme = {
  foreground = "#ffffff",
  background = "#000000",
  cursor_bg = "#ffffff",
  cursor_border = "#ffffff",
  cursor_fg = "#000000",
  selection_bg = "#264f78",
  selection_fg = "#ffffff",
  ansi = {
    "#000000",  -- Black
    "#cd3131",  -- Red
    "#0dbc79",  -- Green
    "#e5e510",  -- Yellow (matching your go-task color)
    "#cc4400",  -- Blue -> Dark Orange (primary color)
    "#bc3fbc",  -- Magenta
    "#11a8cd",  -- Cyan
    "#e5e5e5",  -- White
  },
  brights = {
    "#666666",  -- Bright Black
    "#f14c4c",  -- Bright Red
    "#23d18b",  -- Bright Green
    "#f5f543",  -- Bright Yellow (brighter orange/yellow)
    "#ff6600",  -- Bright Blue -> Medium Dark Orange (primary color)
    "#d670d6",  -- Bright Magenta
    "#29b8db",  -- Bright Cyan
    "#ffffff",  -- Bright White
  },
}

config.colors = dark_theme

-- ====================================
-- STARTUP CONFIGURATION
-- ====================================

-- Start maximized without decorations (borderless fullscreen)
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:maximize()
end)

-- ====================================
-- GHOSTTY-COMPATIBLE KEYBINDINGS
-- ====================================
local act = wezterm.action

-- Allow line breaks in terminal applications
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.keys = {
  -- ===== SPECIAL KEYBINDS =====
  -- Ctrl+Enter for line break in Claude Code (sends a literal newline)
  { key = 'Enter', mods = 'CTRL', action = act.SendString '\n' },

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
  -- Create splits (fixed directions)
  { key = 's', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },   -- Horizontal split (side by side)
  { key = 'd', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- Vertical split (top/bottom)
  { key = 'o', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },   -- Side split
  { key = 'e', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } }, -- Bottom split

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
  { key = 'z', mods = 'CTRL|ALT', action = act.TogglePaneZoomState }, -- Focus single pane (changed from Shift+Enter)
  { key = 'x', mods = 'CTRL|ALT', action = act.CloseCurrentPane { confirm = true } },

  -- ===== ADDITIONAL FEATURES =====
  -- Fullscreen toggle
  { key = 'f', mods = 'CTRL', action = act.ToggleFullScreen },

  -- Copy/Paste (matching Ghostty)
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Font size adjustment
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },

}

-- ====================================
-- ADVANCED FEATURES
-- ====================================

-- Enable scrollback with scrollbar
config.scrollback_lines = 100000

-- Enable scrollbar
config.enable_scroll_bar = true

-- Enable shell integration
config.set_environment_variables = {
  TERM = 'wezterm',
}

-- Fullscreen startup behavior
config.initial_cols = 120
config.initial_rows = 30

-- Start maximized/fullscreen
config.window_close_confirmation = 'NeverPrompt'

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

return config
