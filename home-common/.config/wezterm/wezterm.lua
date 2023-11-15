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
config.color_scheme = 'Dissonance(Gogh)'
-- Ayu Dark, Dissonance, Elementary, Hardcore, Ibm 3270 (High Contrast), Vibrant Ink
config.font =  wezterm.font_with_fallback {
  {
    family = "Inconsolata Nerd Font Mono",
    harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
  },
  'Fira Mono'
}
config.font_size = fontprops.size
-- and finally, return the configuration to wezterm
return config
