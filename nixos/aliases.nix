{ lib, config, ... }:
let
  subSysConfig = subPath:
    lib.debug.traceVal  (lib.strings.normalizePath
    "${config.environment.variables.NIXOS_CONFIG_DIR}/${subPath}");
in {
  programs.zsh = {
    shellAliases = let
      repo_root = "$(git rev-parse --show-toplevel)";
      cmdBuilder = builtins.concatStringsSep ";";
      rebuildCmd = "${subSysConfig "/rebuild"}";
      __re_action_opts = action: opts:
        let
          optString = builtins.concatStringsSep " " [ "--show-trace" ];
          sepPrefixedOpts =
            if builtins.stringLength optString > 0 then " ${optString}" else "";
        in cmdBuilder [
          "${rebuildCmd} ${action}${sepPrefixedOpts}"
          "exec zsh"
        ];
      rebuildSwitch = __re_action_opts "switch" " --show-trace";
      rebuildBoot = __re_action_opts "boot" " --show-trace";
      upSwitch = cmdBuilder [
        "npins -d ${subSysConfig "/npins"} update -f"
        "${rebuildSwitch}"
      ];
    in {
      wm = "sway";
      _conf = "hx ${subSysConfig "/nixos"}";
      _pkg = "hx ${subSysConfig "/nixos/pkg.nix"}";
      _wez = "hx ${subSysConfig "/home/common/.config/wezterm"}";
      _hx = "hx ${subSysConfig "/home/common/.config/helix/config.toml"}";
      _sw = "hx ${subSysConfig "/home/common/.config/sway"}";
      __sw = "hx ${subSysConfig "/nixos/gui.nix"}";
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
      "gp.f" = "git push --force";
      gr = "git restore";
      "gr.." = "git restore " + repo_root;
      grs = "git restore --staged";
      "grs.." = "git restore --staged " + repo_root;
      cd = ''
        custom_cd() {
                        cd $1;
                        echo "";
                        git status 2> /dev/null;
                        echo "";
                        lsd -a;
                      };custom_cd'';
      _work = ''
        workspace() {
          if test -z $1; then
            ws="rust_stable"
          else
            ws=$1
          fi

          code ${config.userHome}/.vscode/workspaces/''${ws}.code-workspace
        };workspace
      '';
    };
  };
}
