
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      gnupg
      keepassxc
      git-credential-keepassxc
  ];
  
  programs = {
   gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };
}
