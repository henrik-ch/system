{ ... }:
{
  programs.zsh = {
    shellAliases =
    let
      repo_root = "$(git rev-parse --show-toplevel)";
      cmdBuilder = builtins.concatStringsSep ";";
      ___re = rebuild_opts: cmdBuilder [
        "sudo ~bzm3r/nixos-conf/rebuild switch${rebuild_opts}"
        "exec zsh"
      ];
      __re = ___re " --show-trace";
      _re = ___re "";
      _up = cmdBuilder [
        "npins -d ~bzm3r/nixos-conf/npins/ update"
        "${_re}"
      ];
    in
    {
      wm = "sway";
      _conf = "hx ~/nixos-conf";
      _core = "hx ~/nixos-conf/core/";
      _usr = "hx ~/nixos-conf/programs/";
      _wez = "hx ~/nixos-conf/home-common/.config/wezterm";
      _hx = "hx ~/nixos-conf/home-common/.config/helix/config.toml";
      _sy = "hx ~/nixos-conf/home-common/.config/sway";
      _nsy = "hx ~/nixos-conf/programs/gui.nix";
      inherit _re __re _up;
      gpg-import = "gpg --import-options restore --import";
      _wipe = "sudo nix-collect-garbage -d";
      _reboot = "sudo reboot -h now";
      _shutdown = "sudo shutdown -h now";
      ls = "lsd -a";
      cat = "bat";
      gs = "ls ; git status";
      gc = "git commit ";
      ugc = "git reset HEAD~";
      "gc." = "git commit -c $(git log -n 1 --format='%H')";
      gcm = "git commit -m ";
      "gc.a" = "git commit --amend --no-edit";
      "gc.a." = "git commit --amend";
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
