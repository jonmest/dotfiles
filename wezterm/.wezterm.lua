-- ~/.wezterm.lua
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- Find fish shell across platforms
local function find_fish()
  local candidates = {
    "/opt/homebrew/bin/fish",   -- macOS Apple Silicon
    "/usr/local/bin/fish",      -- macOS Intel / Linuxbrew
    "/usr/bin/fish",            -- Linux system package
    "/home/" .. (os.getenv("USER") or "") .. "/.cargo/bin/fish",
  }
  for _, path in ipairs(candidates) do
    local f = io.open(path, "r")
    if f then f:close(); return path end
  end
  return nil
end
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  -- ---------- Core look ----------
  font = wezterm.font_with_fallback({
    "Monaspace Neon NF",
    "JetBrainsMono Nerd Font",
  }),
  harfbuzz_features = { "calt", "liga", "ss01", "ss02", "ss03" },
  font_size = 13.0,
  line_height = 1.0,
  cell_width = 1.0,

  -- GitHub Dark Default palette
  colors = {
    foreground = "#c9d1d9",
    background = "#0d1117",
    cursor_bg = "#58a6ff",
    cursor_fg = "#0d1117",
    cursor_border = "#58a6ff",
    selection_bg = "#264f78",
    selection_fg = "#c9d1d9",
    ansi = {
      "#484f58",  -- black
      "#ff7b72",  -- red
      "#3fb950",  -- green
      "#d29922",  -- yellow
      "#58a6ff",  -- blue
      "#bc8cff",  -- magenta
      "#39c5cf",  -- cyan
      "#b1bac4",  -- white
    },
    brights = {
      "#6e7681",  -- bright black
      "#ffa198",  -- bright red
      "#56d364",  -- bright green
      "#e3b341",  -- bright yellow
      "#79c0ff",  -- bright blue
      "#d2a8ff",  -- bright magenta
      "#56d4dd",  -- bright cyan
      "#f0f6fc",  -- bright white
    },
    tab_bar = {
      background = "#010409",
      active_tab = {
        bg_color = "#0d1117",
        fg_color = "#c9d1d9",
      },
      inactive_tab = {
        bg_color = "#010409",
        fg_color = "#6e7681",
      },
      inactive_tab_hover = {
        bg_color = "#161b22",
        fg_color = "#c9d1d9",
      },
      new_tab = {
        bg_color = "#010409",
        fg_color = "#6e7681",
      },
      new_tab_hover = {
        bg_color = "#161b22",
        fg_color = "#58a6ff",
      },
    },
  },

  window_background_opacity = 0.95,
  macos_window_background_blur = 20,     -- frosted glass effect (macOS; no-op on Linux)
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,
  
  -- ---------- Quality of Life ----------
  check_for_updates = false,
  scrollback_lines = 5000,
  automatically_reload_config = true,
  adjust_window_size_when_changing_font_size = false,
  window_padding = {
    left = 16, right = 16, top = 12, bottom = 16,
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
  enable_wayland = false,

  -- ---------- Launch ----------
  default_prog = find_fish() and {find_fish(), "-l"} or nil,
}

