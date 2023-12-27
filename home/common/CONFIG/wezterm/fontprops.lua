local wezterm = require 'wezterm'

local module = {}

function module.apply_to_config(config)
    config.font = wezterm.font_with_fallback {
        'Inconsolata Nerd Font Mono',
        'Nerd Font Symbols',
        'Noto Color Emoji',
        'Source Code Pro',
        'JetBrains Mono',
      }
    config.font_size = 18
end

return module

