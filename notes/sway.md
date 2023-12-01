# GUI daemons

[Managing Sway specific daemons with
systemd](https://wiki.archlinux.org/title/sway#Manage_Sway-specific_daemons_with_systemd)

> Systemd provides a graphical-session.target which is a user unit which is
> active whenever any graphical session is running, whether Xorg or Wayland.
> User services which should run in all graphical environments can be bound to
> that target. It also allows for a window-manager-specific target to be bound
> to graphical-session.target to start and stop services which should run only
> under that window manager. See systemd.special(7)

# Sway startup on login in TTY1

* should already work using NixOS configuration, but just in case, some ideas: <https://gitlab.com/wef/dotfiles/-/blob/master/bin/sway-start>

# Keyboard shortcuts tool

* <https://github.com/MaxVerevkin/wlr-which-key>: advanced, mode based keyboard
  shortcuts for sway? Rust-based.

# Application management

## Autostarting certain apps

* <https://gitlab.com/wef/dotfiles/-/blob/master/bin/sway-start-apps> (convert
  to Rust)
*

## Making certain apps open in certain workspaces

* [Automatically launch applications on specific
  workspace](https://www.reddit.com/r/swaywm/comments/czyiu9/automatically_launch_applications_on_specific/)
* [How to automatically launch apps in certain workspaces in
  SwayWM](https://gist.github.com/3lpsy/9fc13dae3ba9c176013e3f6457b458e2)

# Wezterm ideas

* setting Wezterm as a dropdown terminal:
  <https://gitlab.com/wef/dotfiles/-/tree/master/.config/sway#drop-down-terminal>
* lots of useful ideas here: <https://github.com/ldelossa/sway-fzfify>
  * in particular: alacritty as a "pop-up terminal":

## Using wezterm as an "always on" interactive status bar

* command palette like functionality; can display time etc. can also display
  various tray related info?

## Or, including wezterm as one part of a status bar?

* Clickable, can type into it, etc.?

## Using Wezterm as an application launcher

* [convert this to Rust using `xshell`](https://github.com/Biont/sway-launcher-desktop/blob/master/sway-launcher-desktop.sh)
* create Sway configuration declaratively, so that this app launcher can also
  provide hints on which keys ought to be pressed in order to get a particular
  effect

## Wezterm-based notifications?

* Could use Wezterm here too? maybe a dedicated workspace for the terminal
  where one wezterm tab displays various notifications?
* maybe have a wezterm terminal available in every workspace, and one tab is
  dedicated to notifications of various sorts? --- when a notification is
  available for view, create a small icont hat shows up in swaybar with the
  number of notifications currently around

# Notifications

## Rust-based Wayland + Sway notification?

* <https://gitlab.com/snakedye/salut>

# Workspace

## Making workspace names reflect windows in workspaces

* <https://github.com/Lyr-7D1h/swayest_workstyle>
* <https://github.com/pierrechevalier83/workstyle>

Not sure how useful it may be (especially if we can get a nice Wezterm-based
application launcher customized with our own stuff), but something that might be
worth trying.

# Mode management

# Bar

* bar should autohide/manually hide?

## Rust based

* <https://github.com/danieldg/rwaybar>

## Swaybar content generators

# Misc

* various ideas: <https://gitlab.com/wef/dotfiles/-/tree/master/>
* various ideas, using Rust: <https://git.sr.ht/~tsdh/swayr>
* not entirely sure what this is: <https://github.com/shdown/luastatus>
* I like this, and wish I could do something similar for VS Code: <https://github.com/RasmusLindroth/i3keys>

# Disorganized

* kanata to improve the keyboard expreience (especially for VS Code jank)
  * changing kanata layouts based on which workspace is activated?
* Rust based Wayland hotkey daemon: <https://github.com/waycrate/swhkd>
