-- ~/.wezterm.lua
local wezterm = require 'wezterm'
local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  -- ---------- Core look ----------
  font = wezterm.font_with_fallback({
    { family = "JetBrainsMono Nerd Font", weight = "ExtraLight" },
    { family = "JetBrainsMono Nerd Font", weight = "Light" },
  }),
  font_size = 13.0,
  freetype_load_target = "Light",        -- lighter hinting = smoother glyphs
  freetype_render_target = "HorizontalLcd", -- subpixel AA (sharper on LCD/LED panels)
  cell_width = 1.0,
  line_height = 1.15,                    -- a touch of extra line spacing for breathing room

  -- Claude-inspired warm color scheme
  colors = {
    foreground = "#E8E0D8",
    background = "#1A1714",
    cursor_bg = "#D97757",
    cursor_fg = "#1A1714",
    cursor_border = "#D97757",
    selection_bg = "#4A3F35",
    selection_fg = "#E8E0D8",
    ansi = {
      "#2A2520",  -- black
      "#D97757",  -- red (Claude terracotta)
      "#7DAE82",  -- green
      "#D4A857",  -- yellow
      "#7B9EBF",  -- blue
      "#B588B0",  -- magenta
      "#6FAFAF",  -- cyan
      "#C8BEB4",  -- white
    },
    brights = {
      "#5C534A",  -- bright black
      "#E89578",  -- bright red
      "#9BC49F",  -- bright green
      "#E2C07A",  -- bright yellow
      "#9BB8D4",  -- bright blue
      "#CDA4C8",  -- bright magenta
      "#8EC7C7",  -- bright cyan
      "#E8E0D8",  -- bright white
    },
    tab_bar = {
      background = "#141210",
      active_tab = {
        bg_color = "#1A1714",
        fg_color = "#E8E0D8",
      },
      inactive_tab = {
        bg_color = "#141210",
        fg_color = "#7A7068",
      },
      inactive_tab_hover = {
        bg_color = "#2A2520",
        fg_color = "#C8BEB4",
      },
      new_tab = {
        bg_color = "#141210",
        fg_color = "#7A7068",
      },
      new_tab_hover = {
        bg_color = "#2A2520",
        fg_color = "#D97757",
      },
    },
  },

  window_background_opacity = 0.95,
  macos_window_background_blur = 20,     -- frosted glass effect (macOS; no-op on Linux)
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,
  window_decorations = "RESIZE",         -- remove title bar, keep resize handles
  window_frame = {
    border_left_width = "0.2cell",
    border_right_width = "0.2cell",
    border_bottom_height = "0.1cell",
    border_top_height = "0.1cell",
    border_left_color = "#2A2520",
    border_right_color = "#2A2520",
    border_bottom_color = "#2A2520",
    border_top_color = "#2A2520",
  },
  inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.65,
  },

  -- ---------- Quality of Life ----------
  check_for_updates = false,
  scrollback_lines = 5000,
  automatically_reload_config = true,
  adjust_window_size_when_changing_font_size = false,
  window_padding = {
    left = 16, right = 16, top = 12, bottom = 8,
  },
  cursor_blink_rate = 500,
  default_cursor_style = 'BlinkingBlock',

  -- ---------- Key bindings ----------
  keys = {
    -- New tab
    {key="t", mods="CTRL|SHIFT", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    -- Split horizontally / vertically
    {key="|", mods="CTRL|SHIFT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="_", mods="CTRL|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    -- Switch between panes
    {key="h", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Left"}},
    {key="l", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Right"}},
    {key="k", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Up"}},
    {key="j", mods="CTRL|ALT", action=wezterm.action{ActivatePaneDirection="Down"}},
    -- Close pane/tab
    {key="w", mods="CTRL|SHIFT", action=wezterm.action{CloseCurrentPane={confirm=true}}},
    -- Quick reload config
  },

  -- ---------- Behavior ----------
  enable_kitty_graphics = true, -- enables inline image protocol for neovim plugins etc
  warn_about_missing_glyphs = false,
  enable_wayland = true, -- if you're on Wayland; otherwise ignore

  -- ---------- Launch ----------
  default_prog = {"fish", "-l"},
}

