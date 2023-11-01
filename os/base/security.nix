
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      gnupg
      git-credential-oauth
  ];
  
  programs = {
   gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };
}
