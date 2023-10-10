local wezterm = require 'wezterm'
local config = {}

config.enable_wayland = true
font = wezterm.font 'FiraCode Nerd Font'
config.hide_tab_bar_if_only_one_tab = true

return config
