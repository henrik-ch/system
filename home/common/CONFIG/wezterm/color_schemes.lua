local color_schemes = {}

color_schemes.bzm3r = {
        -- The default text color
        foreground = '#ffffff',
        -- The default background color
        background = '#000000',

        -- Overrides the cell background color when the current cell is occupied by the
        -- cursor and the cursor style is set to Block
        cursor_bg = '#ff8f3f',
        cursor_fg = "#000000",
        -- Specifies the border color of the cursor when the cursor style is set
        -- to Block, or the color of the vertical or horizontal bar when the
        -- cursor style is set to Bar or Underline.
        cursor_border = '#ff8f3f',

        -- the foreground color of selected text
        selection_fg = '#ffffff',
        -- the background color of selected text
        selection_bg = '#663775',

        -- The color of the scrollbar "thumb"; the portion that represents the current viewport
        scrollbar_thumb = '#222222',

        -- The color of the split lines between panes
        split = '#444444',

        ansi = {
            '#000000',
            '#ff5555',
            '#55ff55',
            '#ffff55',
            '#5555ff',
            '#ff55ff',
            '#55ffff',
            '#bbbbbb',
        },
        brights = {
            '#555555',
            '#ff5555',
            '#55ff55',
            '#ffff55',
            '#5555ff',
            '#ff55ff',
            '#55ffff',
            '#ffffff',
        },

        -- Since: 20220319-142410-0fcdea07
        -- When the IME, a dead key or a leader key are being processed and are effectively
        -- holding input pending the result of input composition, change the cursor
        -- to this color to give a visual cue about the compose state.
        compose_cursor = 'orange',

        -- Colors for copy_mode and quick_select
        -- available since: 20220807-113146-c2fee766
        -- In copy_mode, the color of the active text is:
        -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
        -- 2. selection_* otherwise
        copy_mode_active_highlight_bg = { Color = '#375675' },
        copy_mode_inactive_highlight_bg = { Color = '#213447' },
        copy_mode_active_highlight_fg = { Color = '#ffffff' },
        copy_mode_inactive_highlight_fg = { Color = '#c2c2c2' },

        quick_select_label_bg = { Color = '#663775' },
        quick_select_label_fg = { Color = '#ffffff' },
        quick_select_match_bg = { Color = '#375675' },
        quick_select_match_fg = { Color = '#ffffff' },
}

return color_schemes