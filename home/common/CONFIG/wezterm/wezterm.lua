-- Pull in the wezterm API
local wezterm = require 'wezterm'
local fontprops  = require 'fontprops'
local color_schemes = require 'color_schemes'
local keybindings = require 'keybindings'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.default_cursor_style = 'SteadyBlock'

-- For example, changing the color scheme:
config.color_schemes = color_schemes
config.color_scheme = 'bzm3r'

fontprops.apply_to_config(config)
keybindings.apply_to_config(config)

config.unix_domains = {
    {
        name = 'unix',
    },
}

-- and finally, return the configuration to wezterm
return config
