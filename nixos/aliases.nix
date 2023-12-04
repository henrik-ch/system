{ ... }:
{
  programs.zsh = {
    shellAliases =
    let
      repo_root = "$(git rev-parse --show-toplevel)";
      cmdBuilder = builtins.concatStringsSep ";";
      rebuildCmd = "sudo ~bzm3r/nixos-conf/rebuild";
      __re_action_opts = action: opts: cmdBuilder [
        "${rebuildCmd} ${action} ${opts}"
        "exec zsh"
      ];
      rebuildSwitch = __re_action_opts "switch" "";
      rebuildBoot = __re_action_opts "boot" "";
      upSwitch = cmdBuilder [
        "npins -d ~bzm3r/nixos-conf/npins/ update -f"
        "${rebuildSwitch}"
      ];
    in
    {
      wm = "sway";
      _conf = "hx ~bzm3r/nixos-conf/nixos/";
      _pkg = "hx ~bzm3r/nixos-conf/nixos/pkg.nix";
      _wez = "hx ~bzm3r/nixos-conf/home/common/.config/wezterm";
      _hx = "hx ~bzm3r/nixos-conf/home/common/.config/helix/config.toml";
      _sw = "hx ~bzm3r/nixos-conf/home/common/.config/sway";
      __sw = "hx ~bzm3r/nixos-conf/nixos/gui.nix";
      _up = upSwitch;
      _re-s = rebuildSwitch;
      _re-b = rebuildBoot;
      __re = rebuildCmd;
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
