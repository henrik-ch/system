{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
        user = {
          name = "Brian Merchant";
          email = "bhmerchant@gmail.com";
        };
        commit = {
          gpgSign = true;
        };
        core = {
          editor = "hx";
        };
        credential = {
          helper = "manager";
          credentialStore = "gpg";
        };
      };
    };
  };
  
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
        gh
        wakatime
        git-credential-manager
        pass
      ];
    };
  };
}
