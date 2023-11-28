{ ... }:
{
  programs.zsh = {
    shellAliases =
    {
      sy = "sway";
      _conf = "hx ~/nixos-conf";
      _core = "hx ~/nixos-conf/core/default.nix";
      _usr = "hx ~/nixos-conf/core/usr.nix";
      _wez = "hx ~/nixos-conf/home-common/.config/wezterm";
      _hx = "hx ~/nixos-conf/home-common/.config/helix/config.toml";
      _sy = "hx ~/nixos-conf/home-common/.config/sway";
      _nsy = "hx ~/nixos-conf/gui-sway.nix";
      _re = "sudo /home/bzm3r/rebuild switch; exec zsh";
      __re = "sudo /home/bzm3r/rebuild --show-trace switch; exec zsh";
      _up = "cd /home/bzm3r/nixos-conf ; sudo nix flake update ; sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
      gpg-import = "gpg --import-options restore --import";
      _wipe = "sudo nix collect-garbage -d";
      _reboot = "sudo reboot -h now";
      _shutdown = "sudo shutdown -h now";
      ls = "lsd -a";
      cat = "bat";
      gs = "ls ; git status";
      gc = "git clone --recurse-submodules";
      gf = "git fetch";
      gm = "git merge";
      gpull = "git pull ; git submodule update --init --recursive";
      gfm = "git fetch ; git merge";
      gfp = "git fetch ; git pull";
      gd = "git diff";
      gp = "git push --recurse-submodules=check";
      gpod = "git push --recurse-submodules=on-demand";
      gsmr = "git submodule update --remote --rebase";
      gsmm = "git submodule update --remote --merge";
      cd = "f() {
                cd $1;
                echo \"\";
                git status 2> /dev/null;
                echo \"\";
                lsd -a;
              };f";
    };
  };
}