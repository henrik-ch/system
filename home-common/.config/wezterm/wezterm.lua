-- Pull in the wezterm API
local wezterm = require 'wezterm'
local fontprops  = require 'fontprops'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Rasi (terminal.sexy)'
config.font =  wezterm.font_with_fallback {'Inconsolata Nerd Font Mono', 'Fira Mono'}
config.font_size = fontprops.size

-- and finally, return the configuration to wezterm
return config