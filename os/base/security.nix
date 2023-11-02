
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    libsecret
  ];
  
  programs = {
   gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };
}
