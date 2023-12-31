# Sane[^1], stable, and stateless NixOS setup

This is a fairly straightforward setup for making a NixOS system configuration
stateless without relying on experimental Nix features or 3rd party Nix tools.
Based on
[infinisil/sane-stable-nixos](https://github.com/infinisil/sane-stable-nixos).

[^1]: Where sanity is defined as: no flakes, no `home-manager`, and [no `flake-utils`](https://ayats.org/blog/no-flake-utils/).

## Why?

> I want to inspire you to raise your quality standards. I mean, if 10 years
> from now, when you are doing something quick and dirty, you suddenly visualize
> that I am looking over your shoulders and say to yourself "[Dijkstra would not
> have liked this."](https://www.cs.utexas.edu/users/EWD/transcriptions/EWD12xx/EWD1213.html), well, that would be enough immortality for me.

The following thoughts ultimately motivate this repository's approach:

- It is worth breaking out of the shackles of UNIX.
- A small step, is good enough; and "good enough" *is*.
- Elegance can make a human being laugh.
- Nix/NixOS is not easy to learn, but not because it has bad documentation, as
  is commonly believed. Instead, Nix/NixOS's learning curve is exacerbated by:
    1. power struggles within the Nix/NixOS community, due to powerful entities believing:
        - it is not possible to ease the use and documentation of a programming language
          (and ultimately, the art of reasoning) through the use of conceptual and mental aids and tools;
        - that Nix ought to be profited from through commercialization of
            the current version regardless of its limitations, therefore it is better to invest in building attractive websites and beguiling graphical installers, rather than documentation/contributor/maintenance teams.
    2. the production of a number of tools meant to "simplify" Nix/NixOS, without understanding that:
         1. Nix/NixOS is [a fundamental repudiation of the "UNIX philosophy"](https://www.tweag.io/blog/2022-07-14-taming-unix-with-nix/);
         2. if you only wish to give out free fish to attract new people, but
         refuse to teach them how to fish, then you are not building a
         community;
         3. and it is not helpful for beginners, to watch as a tool pulls out magic rabbits from a hat.
    3. the production of a large number of blog posts that do not expose the
    principles behind Nix/NixOS and instead meme-ify the usage (configuration) of
    Nix (NixOS) by presenting a recipe the user may follow. This memetization is
    amplified by search engine algorithms.

## Features

- No flakes: a pinned `nixpkgs` is used for the system and all Nix commands (including the
  `nixpkgs` version, config and overlays); but without the complexity of flakes
  and instead through [a much simpler alternative]([npins](https://github.com/andir/npins) [^2] (note:
  infinisil uses `niv` instead))
- `nix-channel` is disabled
- No `home-manager`: for now, simple `./nixos/setup-scripts` are used to create
  symlinks from `./home` into the user's home.
- Uses Rust-based tools wherever possible, in preference to Go or C
- Uses Sway + Wayland for GUI
- (suggested, hidden) mini-exercise: customize your shell prompt with Starship, but *do
  not* write out a toml file manually; instead, use only Nix to help set you up.
  (This was how I ended up becoming comfortable with the Nix language; maybe it
  will work for you too, or inspire you to create a similar project for
  yourself.)

[^2]: Yes `npins` is a third-party tool, but it's essentially just a nice
    wrapper around `nix-prefetch-url` and co.

## TODO

- [ ] replace manual symlinking with a simple `systemd` based service ([see](https://gist.github.com/bzm3r/410fc1bcd1f22426a266a7af2b61bdf3))
- [ ] replace shell scripts with Rust
- [ ] convert into a system configuration template
- [ ] provide a template for quickly starting a "Rust CLI script" project
- [ ] clean the mess around which particular configuration (`d` or `l`) is
generated. (This is partially complete.)
- [ ] provide better instructions on how to switch from a flake based setup to a
sane setup
- [ ] provide links to relevant Nix lang programming resources in `starship.nix`,
and a simple "blank canvas" that can be filled out further.

## Usage

Unlike infinisil's setup, which can be used as a system configuration template,
this is not (yet, see TODO) exactly system
template, as it contains personalized details regarding the management of my own
systems (e.g. almost everything under `./nixos` and `./home`).

You can still clone it and use it as a template, but make sure to change things
so that they suit your own needs (at the very least, change all occurrences of
my username?).

### Setup

The following assumes that you just installed NixOS by going through the
[official installation
docs](https://nixos.org/manual/nixos/stable/#sec-installation). If you have a
flake-based system configuration, you might have to follow slightly different
steps (not listed out here)

1. Clone this repo to a local directory and enter it:

   ```sh
   nix-shell -p git --run \
     'git clone https://github.com/bzm3r/system'
   cd system
   ```

2. Add your initial NixOS configuration files, either
   - Move your existing configuration files into it:

     ```sh
     sudo mv /etc/nixos/* .
     ```

   - Generate new ones (into the `system` directory):

     ```sh
     nixos-generate-config --dir .
     ```

3. Pin `nixpkgs` to the [latest unstable (rolling release) version](https://nixos.org/manual/nixos/unstable/release-notes) using [npins](https://github.com/andir/npins):

   ```sh
   nix-shell -p npins --run \
     'npins init'
   ```

4. Remove all stateful channels:

   ```sh
   sudo rm -v /nix/var/nix/profiles/per-user/*/channels*
   ```

5. Rebuild:

   ```sh
   sudo ./rebuild switch
   ```

6. Log out and back in again.

### Making changes

Here are some changes you can make:

- Please point out mistakes you find and please suggest better alternatives for
  any existing process. This repository is very far from being elegant as it stands.
- Replaces occurrences of `bzm3r` with your own string.
- Change the NixOS configuration in `./nixos/configuration-template.nix`
- Update the pinned `nixpkgs`:

  ```sh
  npins update -f nixpkgs
  ```

- Upgrade to a newer release (not sure yet if this is what `npins upgrade` does):

  ```sh
  npins upgrade
  ```

- Change the `nixpkgs` config by editing `nixpkgs/config.nix`
- Add `nixpkgs` overlays to `nixpkgs/overlays.nix`
- Regenerate the hardware configuration:

  ```sh
  nixos-generate-configuration --dir .
  ```

To apply the changes, run

```sh
sudo ./rebuild switch
```

All options to `./rebuild` are forwarded to `nixos-rebuild`.

After rebuilding, the changes are reflected in the system.

Furthermore, all Nix commands on the system will also use the the same values.
