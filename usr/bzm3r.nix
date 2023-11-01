{ pkgs, ... }:

{
  pkgs.config.allowUnfreePredicate =
    package:
      builtins.elem (pkgs.lib.getName package) [ "vscode" "discord" ];

  users = {
    defaultUserShell = "zsh";

    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extragroups = [ "wheel" "networkmanager" ];
      useDefaultShell = true;

      packages = with pkgs; [
        nil
        vscode
        discord
        github-desktop
      ];
    };
  };
}
