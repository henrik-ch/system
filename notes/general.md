- switch Sway to using the Vulkan backend for wlr

- Rust script that allows for easy command line searching of various small notes
  (from a central note file)

- Rust script to help manage what the current task is, and how it is nested with
  other tasks

- should convert all shell aliases to actual Rust scripts that are installed by
  NixOS

- make a Rust script which allows for easy nix-init from git repo

- create script wrapper that allows for templat-ized application of a script (i.e. better xargs)

## Nix related

#### How does NixOS know that it should not delete the build artifacts needed to run a `shell.nix`?

<https://nixos.org/manual/nix/stable/release-notes/rl-0.10.html#release-010-2006-10-06>
