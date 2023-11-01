{ pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    package:
      builtins.elem (pkgs.lib.getName package) [ "vscode" "discord" ];

  users = {
    defaultUserShell = "${pkgs.zsh}/bin/zsh";

    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extraGroups = [ "wheel" "networkmanager" ];
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
