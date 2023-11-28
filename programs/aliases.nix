{ ... }:
{
  programs.zsh = {
    shellAliases =
    let
      repo_root = "$(git rev-parse --show-toplevel)";
      _re = "sudo /home/bzm3r/nixos-conf/rebuild switch; exec zsh";
    in
    {
      sy = "sway";
      _conf = "hx ~/nixos-conf";
      _core = "hx ~/nixos-conf/core/default.nix";
      _usr = "hx ~/nixos-conf/core/usr.nix";
      _wez = "hx ~/nixos-conf/home-common/.config/wezterm";
      _hx = "hx ~/nixos-conf/home-common/.config/helix/config.toml";
      _sy = "hx ~/nixos-conf/home-common/.config/sway";
      _nsy = "hx ~/nixos-conf/gui-sway.nix";
      inherit _re;
      __re = "sudo /home/bzm3r/nixos-conf/rebuild --show-trace switch; exec zsh";
      _up = "cd /home/bzm3r/nixos-conf ; npins update ; ${_re} ; exec zsh";
      gpg-import = "gpg --import-options restore --import";
      _wipe = "sudo nix-collect-garbage -d";
      _reboot = "sudo reboot -h now";
      _shutdown = "sudo shutdown -h now";
      ls = "lsd -a";
      cat = "bat";
      gs = "ls ; git status";
      gc = "git commit";
      "gc.a" = "git commit --amend";
      gf = "git fetch";
      gm = "git merge";
      gpull = "git pull ; git submodule update --init --recursive";
      gfm = "git fetch ; git merge";
      gfp = "git fetch ; git pull";
      gd = "git diff";
      ga = "git add";
      "ga.." = "git add " + repo_root;
      gp = "git push --recurse-submodules=check";
      "gp.f"  = "git push --force";
      gr = "git restore";
      "gr.." = "git restore " + repo_root;
      grs = "git restore --staged";
      "grs.." = "git restore --staged " + repo_root;
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